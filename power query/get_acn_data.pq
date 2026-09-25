let
    BaseApi = "https://ev.caltech.edu/api/v1/",
    FirstQuery = "sessions/caltech?where=connectionTime>=""Tue, 1 Jan 2019 00:00:00 GMT"" and connectionTime<=""Fri, 1 Apr 2019 00:00:00 GMT""",

    GetPage = (relPath as nullable text) =>
        if relPath = null then
            [Items = null, NextHref = null]
        else
            let
                Source = Json.Document(Web.Contents(BaseApi, [RelativePath = relPath])),
                Items = Source[_items],
                NextHref = try Source[_links][next][href] otherwise null
            in
                [Items = Items, NextHref = NextHref],

    Pages = List.Generate(
        () => GetPage(FirstQuery),
        each _[Items] <> null,
        each GetPage(_[NextHref]),
        each _[Items]
    ),

    AllItems = List.Combine(Pages),
    ItemsTable = Table.FromList(AllItems, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Expanded = Table.ExpandRecordColumn(ItemsTable, "Column1",
        {"connectionTime","disconnectTime","doneChargingTime","kWhDelivered","sessionID","siteID","stationID","spaceID","userID"})
in
    Expanded