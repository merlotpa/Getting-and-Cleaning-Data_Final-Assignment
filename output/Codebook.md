# Codebook

This codebook describes the [tiny data set](../output/tidy_data.txt) generated from other data coming from smartphones' sensors: all the variables, their values along with units and any other relevant information are described in this file.

The original raw data represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones),

and the data of that project can be found here: 

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


## Variables


| Variable name | Description                                                                                                                                                         |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| subject       | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.                                                                        |
| activity      | The type of activity performed by the subject ("LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS")                                |
| domainType    | The domain of signal processing: Time domain (time) or frequency domain (freq)                                                                                      |
| sensorType    | The type of sensor used (accelerometer or gyroscope)                                                                                                                |
| axisDir       | The direction of the 3-axial signals (X, Y, Z) when computed over all directions                                                                                    |
| statsType     | The type of statistical function applied to the signal values (Mean value or Standard deviation)                                                                    |
| accType       | The type acceleration signal when separated into Body and Gravity acceleration signals  using another low pass Butterworth filter with a corner frequency of 0.3 Hz |
| isJerk        | A boolean indicating a Jerk signal derived in time from the body linear acceleration or the angular velocity                                                        |
| isMagnitude   | A boolean if it is the magnitude of the signal over these 3D signals calculated using the Euclidean norm                                                            |
| average       | The average of each variable for each activity and each subject                                                                                                     |


## Dataset structure

This dataset follows the  principles of a tiny data:

* each variable forms a column
* each observation forms a row

```r
> tidy_data
```

```r
       subject         activity domainType    sensorType axisDir statsType accType isJerk isMagnitude     average
    1:       1           LAYING       freq accelerometer      NA      mean    Body     NA         Mag -0.86197892
    2:       1           LAYING       freq accelerometer      NA      mean    Body   Jerk         Mag -0.93783365
    3:       1           LAYING       freq accelerometer      NA       std    Body     NA         Mag -0.81131019
    4:       1           LAYING       freq accelerometer      NA       std    Body   Jerk         Mag -0.92723232
    5:       1           LAYING       freq accelerometer       X      mean    Body     NA          NA -0.93909905
   ---                                                                                                           
11156:      30 WALKING_UPSTAIRS       time     gyroscope       Y       std    Body   Jerk          NA -0.74333696
11157:      30 WALKING_UPSTAIRS       time     gyroscope       Z      mean    Body     NA          NA  0.08146993
11158:      30 WALKING_UPSTAIRS       time     gyroscope       Z      mean    Body   Jerk          NA -0.03641578
11159:      30 WALKING_UPSTAIRS       time     gyroscope       Z       std    Body     NA          NA -0.21157358
11160:      30 WALKING_UPSTAIRS       time     gyroscope       Z       std    Body   Jerk          NA -0.66515062
> 
```


## Dataset Summary



```r
> summary(tidy_data)
```

```r
    subject       activity          domainType         sensorType          axisDir         
 Min.   : 1.0   Length:11160       Length:11160       Length:11160       Length:11160      
 1st Qu.: 8.0   Class :character   Class :character   Class :character   Class :character  
 Median :15.5   Mode  :character   Mode  :character   Mode  :character   Mode  :character  
 Mean   :15.5                                                                              
 3rd Qu.:23.0                                                                              
 Max.   :30.0                                                                              

  statsType           accType             isJerk          isMagnitude           average       
 Length:11160       Length:11160       Length:11160       Length:11160       Min.   :-0.9977  
 Class :character   Class :character   Class :character   Class :character   1st Qu.:-0.9616  
 Mode  :character   Mode  :character   Mode  :character   Mode  :character   Median :-0.4435  
                                                                             Mean   :-0.4737  
                                                                             3rd Qu.:-0.0705  
                                                                             Max.   : 0.9745  
> 
```

## Download the tiny data set

You can download the tiny data from this text file [`tidy_data.txt`](../output/tidy_data.txt), 

or regenerate it using this command, after running the R script [`run_analysis.r`](../src/run_analysis.R):


```r
write.table(tidy_data, file = "tidy_data.txt")
```

