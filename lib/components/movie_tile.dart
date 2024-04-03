import 'package:flutter/material.dart';
import 'package:teleplay/screens/video_player.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQwpJ8IfgIgAWXakj6RmObG9FtIL_tmtaESA",
                height: 100,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "22-03-23",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Jawaan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "2023",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Hindi,Telugu,Tamil",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.copy,
                size: 35,
              ),
            )
          ],
        ),
      ),
    );
  }
}
