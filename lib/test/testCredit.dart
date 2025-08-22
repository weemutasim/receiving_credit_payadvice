/* ElevatedButton(
  onPressed: () async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  },
  child: const Text('เลือกวันที่'),
),
Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(6, (index) {
              return Container(
                width: 100,
                height: 80,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10, right: index == 5 ? 100 : 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.btBgColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: blur,
                      offset: -distan,
                      color: Colors.white,
                      inset: false
                    ),
                    BoxShadow(
                      blurRadius: blur,
                      offset: distan,
                      color: const Color(0xFFA7A9AF), //Color(0xFFA7A9AF)
                      inset: false
                    )
                  ]
                ),
                child: Text('Button'),
              );
            })
          )
 */
