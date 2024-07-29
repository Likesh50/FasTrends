import 'package:fastrends/Main_Pages/Layout.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  ExplorePage({required this.onItemTapped, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: ExploreContent(),
      title: 'Explore',
      onItemTapped: onItemTapped,
      currentIndex: currentIndex,
    );
  }
}

class ExploreContent extends StatelessWidget {
  final List<NewsCardData> sampleNews = [
    NewsCardData(
      title: "Rising Star Emerges: Young Athlete's Journey to Victory",
      description: "Just Now - 5 mins read",
      category: "Sports",
      imageUrl: "https://via.placeholder.com/400",
    ),
    NewsCardData(
      title: "Work-Life Harmony 101: Navigating the Future",
      description: "Just Now - 5 mins read",
      category: "Lifestyle",
      imageUrl: "https://via.placeholder.com/400",
    ),
    // Add more sample data here
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in Nova News',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          CategoryFilters(),
          NewsCard(data: sampleNews[0]),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recent News',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          NewsFeed(newsData: sampleNews),
        ],
      ),
    );
  }
}

class NewsCardData {
  final String title;
  final String description;
  final String category;
  final String imageUrl;

  NewsCardData({
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
  });
}

class NewsCard extends StatelessWidget {
  final NewsCardData data;

  const NewsCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (data.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  data.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 10.0),
            Text(
              data.category,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Color(0xFF1F41BB)),
            ),
            SizedBox(height: 5.0),
            Text(
              data.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 5.0),
            Text(
              data.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class NewsFeed extends StatelessWidget {
  final List<NewsCardData> newsData;

  const NewsFeed({Key? key, required this.newsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: newsData.map((news) {
        return NewsCard(data: news);
      }).toList(),
    );
  }
}

class CategoryFilters extends StatelessWidget {
  final List<String> categories = [
    "All",
    "Trending",
    "Politics",
    "Sports",
    "Business"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilterChip(
              label: Text(category),
              onSelected: (bool value) {
                // Handle category selection
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
