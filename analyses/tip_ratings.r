plot(unigrams_freq_single_good$value, unigrams_freq_single_good$frequency)
model = lm(unigrams_freq_single_good$frequency ~ unigrams_freq_single_good$value)
abline(model, col = "green")
summary(model)
coef(model)


plot(unigrams_freq_single_bad$value, unigrams_freq_single_bad$frequency)
model = lm(unigrams_freq_single_bad$value ~ unigrams_freq_single_bad$frequency)
abline(model, col = "red")

plot(unigrams_freq_single_try$value, unigrams_freq_single_try$frequency)
model = lm(unigrams_freq_single_try$frequency ~ unigrams_freq_single_try$value)
abline(model, col = "blue")

plot(unigrams_freq_summary$frequency, unigrams_freq_summary$mean)
stripchart(unigrams_freq_summary$mean, method = 'jitter')

par(mfrow=c(2,1))
plot(floor(tips_ratings$value), tips_ratings$frequency, col='red', pch = 19)
lines(tips_ratings$value, tips_ratings$frequency, type='b')
text(tips_ratings$value, tips_ratings$frequency, labels=tips_ratings$frequency, cex= 0.7, pos=3)
model = lm(tips_ratings$frequency ~ tips_ratings$value)
abline(model, col = "blue")

plot(tips_ratings_2$value, tips_ratings_2$frequency, col='red', pch = 19)
text(tips_ratings_2$value, tips_ratings_2$frequency, labels=tips_ratings_2$frequency, cex= 0.7, pos=3)

plot(tips_ratings_3$value, tips_ratings_3$frequency, col='red', pch = 19)
text(tips_ratings_3$value, tips_ratings_3$frequency, labels=tips_ratings_3$frequency, cex= 0.7, pos=3)

plot(tips_ratings_4$value, tips_ratings_4$frequency, col='red', pch = 19)
text(tips_ratings_4$value, tips_ratings_4$frequency, labels=tips_ratings_4$frequency, cex= 0.7, pos=3)


plot(tips_ratings_5$value, tips_ratings_5$frequency, col='red', pch = 19)
text(tips_ratings_5$value, tips_ratings_5$frequency, labels=tips_ratings_5$frequency, cex= 0.7, pos=3)

par(mfrow=c(2,1))
plot(tips_ratings$value, tips_ratings$frequency, col='red', pch = 19)
text(tips_ratings$value, tips_ratings$frequency, labels=tips_ratings$frequency, cex= 0.7, pos=3)

plot(tips_ratings_7$value, tips_ratings_7$frequency, col='red', pch = 19)
text(tips_ratings_7$value, tips_ratings_7$frequency, labels=tips_ratings_7$frequency, cex= 0.7, pos=3)

plot(tips_ratings_8$value, tips_ratings_8$frequency, col='red', pch = 19)
text(tips_ratings_8$value, tips_ratings_8$frequency, labels=tips_ratings_8$frequency, cex= 0.7, pos=3)
