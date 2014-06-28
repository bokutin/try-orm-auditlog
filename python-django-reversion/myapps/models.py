from django.db import models

class Song(models.Model):
    title = models.CharField(max_length=50)
    fans = models.ManyToManyField('User', through='SongUser')

class User(models.Model):
    username = models.CharField(max_length=50)
    favorite_songs = models.ManyToManyField('Song', through='SongUser')

class SongUser(models.Model):
    song = models.ForeignKey(Song)
    user = models.ForeignKey(User)

import reversion
reversion.register(Song)
reversion.register(User)
reversion.register(SongUser)

# Create your models here.
