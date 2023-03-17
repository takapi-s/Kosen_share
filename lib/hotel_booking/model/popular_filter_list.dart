class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static void changeSelectList(){
    for (var data in popularFList) {
      if (data.isSelected) {
        selectedList[0] = data;
      }
    }
    for (var data in popularCList) {
      if (data.isSelected) {
        selectedList[1] = data;
      }
    }
    for (var data in termList) {
      if (data.isSelected) {
        selectedList[2] = data;
      }
    }
  }

  static List<PopularFilterListData> selectedList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: '1',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: '共通科目',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: '前期',
      isSelected: true,
    ),
  ];

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: '1',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: '2',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: '3',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: '4',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: '5',
      isSelected: false,
    ),
  ];


  static List<PopularFilterListData> popularCList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: '共通科目',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'S系科目',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'M系科目',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'E系科目',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'C系科目',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> termList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: '前期',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: '後期',
      isSelected: false,
    )
  ];

  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'All',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Apartment',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Home',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Villa',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Hotel',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Resort',
      isSelected: false,
    ),
  ];
}


