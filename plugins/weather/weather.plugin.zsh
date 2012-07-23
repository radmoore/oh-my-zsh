# Crude version
# This is originally from somebody else, but I do not
# know who.
weather() {
    emulate -L zsh
    [[ -n "$1" ]] || { 
        print 'Usage: weather <station_id>' >&2
        print 'List of stations: http://en.wikipedia.org/wiki/List_of_airports_by_ICAO_code'>&2
        return 1
    }    

    local PLACE="${1:u}"
    local FILE="$HOME/.weather/$PLACE"
    local LOG="$HOME/.weather/log"

    [[ -d $HOME/.weather ]] || { 
        print -n "Creating $HOME/.weather: "
        mkdir $HOME/.weather
        print 'done'
    }    

    print "Retrieving information for ${PLACE}:"
    print
    wget -T 10 --no-verbose --output-file=$LOG --output-document=$FILE --timestamping http://weather.noaa.gov/pub/data/observations/metar/decoded/$PLACE.TXT

    if [[ $? -eq 0 ]] ; then 
        if [[ -n "$VERBOSE" ]] ; then 
            cat $FILE
        else 
            cat $FILE
            #DATE=$(grep 'UTC' $FILE | sed 's#.* /##')
            #TEMPERATURE=$(awk '/Temperature/ { print $4" degree Celcius / " $2" degree Fahrenheit" }' $FILE| tr -d '(') 
            #echo "date: $DATE"
            #echo "temp:  $TEMPERATURE"
        fi   
    else 
        print "There was an error retrieving the weather information for $PLACE" >&2
        cat $LOG 
        return 1
    fi   
}

