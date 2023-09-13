h = game:GetService'HttpService'
pasteData = h:UrlEncode( h:JSONEncode(ImgScript) )
h:PostAsync(
    'http://pastebin.com/api/api_post.php',
    'api_dev_key=-5fPRpR-QLCvt-TLb_3jh_m89nfABZpq&api_option=paste&api_paste_code=' .. pasteData,
    2
)