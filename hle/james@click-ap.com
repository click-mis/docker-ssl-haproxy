[
    {
        "domain": ["demo.moodle.com.tw"],
        "server": ["192.168.1.202:80"],
        "redirecthttps": false
    },
    {
        "domain": ["hosp.moodle.com.tw"],
        "server": ["192.168.1.3:80"]
    },
    {
        "domain": ["hr.moodle.com.tw"],
        "server": ["192.168.1.7:80"],
        "redirecthttps": false
    },
    {
        "domain": ["enterprise.moodle.com.tw"],
        "server": ["192.168.1.202:80"],
        "redirecthttps": false
    },
    {
        "domain": ["stream.moodle.com.tw"],
        "server": ["192.168.1.61:81"]
    }
]