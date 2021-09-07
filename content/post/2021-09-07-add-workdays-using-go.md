---
title: "Add Workdays Using Go"
thumbnailImage: https://image.shutterstock.com/image-photo/hand-turns-dice-changes-word-260nw-1457643776.jpg
coverImage: https://static01.nyt.com/images/2019/11/08/opinion/06newport/06newport-mobileMasterAt3x.jpg
coverCaption: https://www.nytimes.com/2019/11/06/opinion/five-hour-workday-experiment.html
metaAlignment: center
coverMeta: out
date: 2021-09-07T11:17:16+07:00
categories:
- programming
tags:
- golang
- datetime
description: "Add working days using Golang to avoid working on the weekend"
---

Go [time package](https://pkg.go.dev/time) has extensive support for manipulating times and durations. For example, we can use the time package to find the next business days. Let's create a small case for this.
<!--more-->

## Study Case
We want to create a Gantt chart data for our to-do app project. We will break down the tasks into a sequential task.

1. UI/UX design (5 days)
2. Implementing the frontend (3 days)
3. Implementing the backend (2 days)

Let's assume that this project will start on 9 August 2021. So this project will end on 20 August 2021.

## Data Structure
Each task will have these types

```go
package main

type Task struct {
    // Name of the task e.g. UI/UX design, FE, BE, etc
    Name string

    // Duration of the task
    Duration int
}
```

and let's mix them up into an array of `Task`

```go
package main

var tasks = []Task{
    {Name: "UI/UX Design", Duration: 5},
    {Name: "FE Implementation", Duration: 3}, 
    {Name: "BE Implementation", Duration: 2}, 
}
```

Don't forget to create the Gantt chart data structure too

```go
package main

type Data struct {
    Name      string
    StartDate time.Time
    EndDate   time.Time
}

var data []Data
```

## Implementation
There are lots of solutions out there and recursive is the neat solution to handle this case. Let's start with the function param signature first

```go
func AddWorkdays(date time.Time, days int) time.Time {
...
}
```

we have `date` as `time.Time` which we will use as our start date. And we have `days` as `int` which we will use as how many days we want to add.

Since we're doing recursive, we will add a `do...while` loop and add a stopping point to it. So we won't have an infinite loop. The idea is we will decrement the `days` on each iteration and we will stop if the `days` value is zero.

```go
func AddWorkdays(date time.Time, days int) time.Time {
    for {
        if (days == 0) {
            return date
        }

        ...
        days--
    }
}
```

Now come to the fun parts. The main idea of this function is we keep adding more days until the `days` are zero. And it will skip the weekend days (Saturday and Sunday) to Monday.
 

```go
func AddWorkdays(date time.Time, days int) time.Time {
   for {
        if (days == 0) {
            return date
        }

        date = date.AddDate(0, 0, 1)
       
        if date.Weekday() == time.Saturday {
            date = date.AddDate(0, 0, 2)
            return AddWorkdays(date, days-1)
        } else if date.Weekday() == time.Sunday {
            date = date.AddDate(0, 0, 1)
            return AddWorkdays(date, days-1)
        }

        days--
   }
}
```

The logic is quite simple
1. Add one day on each iteration
2. If the current date (after addition) is Saturday, we will add two more days. So it will skip to Monday
3. It's like the logic above. But, we only add one more day if the current date is Sunday
4. Before return back to the same function, we decrement the `days` by one
5. Once it comes to the next iteration, the `date` already has the addition to it. And the `days` already had the subtraction
6. And the function will continue until the `days` is zero

{{< alert warning >}}
Please note that the function will always end up with one more day than intended. For example, if we add 4 days from 9 August 2021, it will end up at 13 August 2021. 
{{< /alert >}}

## The Calculation

Now let's do the calculation for adding workdays. Let's begin with iterate the `tasks`  and put the calculated date to our `data []Data`. Don't forget that our start date is from 9 August 2021.

```go
...
firstDate, _ := time.Parse("2006-01-02 00:00:00", "2021-08-09 00:00:00")
var data []Data

for k, v := range tasks {
    d:= Data{}
 
    // let's assume that the first index is the start date
    if k == 0 {
        d.StartDate =  firstDate 
        d.EndDate = AddWorkdays(firstDate ,  v.Duration-1)
    } else {
        start := data[k-1].EndDate
        startDate :=  AddWorkdays(start, 1) 
        d.StartDate = startDate
        d.EndDate = AddWorkdays(starDate, v.Duration-1)
    }
 
    data = append(data, d) 
}
...
```

The logic is like this
1. We iterate the `tasks`
2. We will assume that the first index is always the start date of the project
3. If it's the first day, we will assign the `StartDate` with the `firstDate`. For the `EndDate`, we will use the `AddWorkdays` function to add days based on duration (`v.Duration`). Don't forget to subtract by one day since the function has a gotcha
4. If it's the rest of the days, we will use the `EndDate` from the last element as the start date. And we will add one day so the start date won't clash with the end date from the previous element. The `EndDate` use the same logic as above
5. Append the calculated data to the `[]Data`

If we want to print the result, we can use a JSON pretty print (`json.MarshalIndent`).

## Result

{{< tabbed-codeblock main.go "" >}}
<!-- tab go -->
package main

type Task struct {
    // Name of the task e.g. UI/UX design, FE, BE, etc
    Name string

    // Duration of the task
    Duration int
}

type Data struct {
    Name      string
    StartDate time.Time
    EndDate   time.Time
}

var tasks = []Task{
    {Name: "UI/UX Design", Duration: 5},
    {Name: "FE Implementation", Duration: 3}, 
    {Name: "BE Implementation", Duration: 2}, 
}

function main() {
    firstDate, _ := time.Parse("2006-01-02 00:00:00", "2021-08-09 00:00:00")
    var data []Data
    for k, v := range tasks {
        d := Data{Name: v.Name}

        // let's assume that the first index is the start date
        if k == 0 {
            d.StartDate = firstDate
            d.EndDate = AddWorkdays(firstDate, v.Duration-1)
        } else {
            start := data[k-1].EndDate
            startDate := AddWorkdays(start, 1)
            d.StartDate = startDate
            d.EndDate = AddWorkdays(startDate, v.Duration-1)
        }

        data = append(data, d)
    }

    json, _ := json.MarshalIndent(data, "", "  ")
    fmt.Printf("Data %s", json)
}

<!-- endtab -->

<!-- tab json -->
// Output
Data [
  {
    "Name": "UI/UX Design",
    "StartDate": "2021-08-09T00:00:00Z",
    "EndDate": "2021-08-13T00:00:00Z"
  },
  {
    "Name": "FE Implementation",
    "StartDate": "2021-08-16T00:00:00Z",
    "EndDate": "2021-08-18T00:00:00Z"
  },
  {
    "Name": "BE Implementation",
    "StartDate": "2021-08-19T00:00:00Z",
    "EndDate": "2021-08-20T00:00:00Z"
  }
]
<!-- endtab -->
{{< /tabbed-codeblock >}}

## References
- https://pkg.go.dev/time
- https://yourbasic.org/golang/do-while-loop/