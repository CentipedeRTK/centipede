from ntripbrowser import NtripBrowser

browser = (NtripBrowser('caster.centipede.fr', port=2101,timeout=10))
getmp= browser.get_mountpoints()
flt = getmp['str']
for i in flt:
    mp = i["Mountpoint"]
    print(mp)
