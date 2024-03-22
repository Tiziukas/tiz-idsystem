Config = {}

--Fake ID configuration
Config.NPCLocation = vec3(-2026.6785, -369.7483, 19.0969) -- Where should the FakeID NPC be?
Config.NPCLocationheading = 203.1064 -- Which was is the NPC looking?
Config.NPCModel = 'a_m_m_business_01' -- Model of the NPC that sells the ID.
Config.Price = 2500 -- How much of the item below should the player have?
Config.PaymentType = "black_money" -- Input an item.
Config.Item = true -- Do you want the player to receive the FakeID upon payment?
Config.DeleteAfterRestart = false -- Wipes FakeID from DB after restart.

--Legal ID Redeem NPC
Config.EnableRedeemNpc = true
Config.NPCLicenseLocation = vec3(-700.3138, 299.5370, 83.2174) -- Where should the NPC be?
Config.NPCLicenseLocationheading = 163.9565 -- Which was is the NPC looking?
Config.NPCLicenseModel = 'a_m_m_business_01' -- Model of the NPC that gives the ID.

--Full list/Command Configuration.
Config.CommandOn = true  -- Turns the command on or off.
Config.Command = "licenses" -- Command to open the menu.

-- Item names for all IDS
Config.ItemNames = {
    fakeid = 'fakeid', --License item name or false to disable it.
    id = "id",
    drivers = "drivers",
    weapon = "weapon",
    medic = "medic"
}
Config.UseableItems = true -- Do you want the items to open up their seperate menus when used? (true) or are you okay with just metadata on the items? (false)

Config.LicenseNames = {
    medic = "mediku_pazyma",
    weapon = "weapon"
}
Config.Language = {
    buy = 'Buy a fake ID!',
    buydescription = 'Ask the plug for an ID!',
    idmenu = 'Buy an ID',
    name = 'First Name',
    namedesc = 'Add your name here',
    lname = 'Last Name',
    lnamedesc = 'Add your last name here',
    dobas = 'Date of Birth',
    gender = 'Gender',
    male = 'Male',
    female = 'Female',
    category = 'Category',
    height = 'Height',
    notifytitle = 'Plug',
    notifysucces = 'You received a Fake ID!',
    notifyalready = 'You already have a license!',
    notifymoney = 'You do not have enough money!',
    pedname = 'Plug',
    menudesc = 'No one nearby!',
    titlemenu = 'Fake ID Menu',
    menutitle = 'Fake ID Dealer',
    categorya = 'A',
    categoryb = 'B',
    idtitle = 'Options:',
    categoryc = 'C',
    checktitle = 'Check your Fake ID',
    checkdesc = 'Displays the ID to you',
    showtitle = 'Show your Fake ID',
    showkdesc = 'Shows your ID to the closest person',
    eyepedname = 'Plug',
    pricemeta = 'Price of an ID $',
    nolicense = 'You do not have this license!',
    checkmedic = "Check your health license",
    showmedic = "Show your health license",
    checkweapon = "Check your weapon license",
    showweapon = "Show your weapon license",
    checkdrivers = "Check your drivers",
    showdrivers = "Show your drivers license",
    checkid = "Check your ID",
    showid = "Show your ID",
    redeemid = "Redeem your ID",
    redeemdid = "Redeem your Drivers License",
    redeewdid = "Redeem your Weapon license",
    redeehdid = "Redeem your health license.",
    mediclicenseitemmeta = "Medic License",
    weaponlicenseitemmeta = "Weapon License",
    driverslicenseitemmeta = "Drivers License",
    redeemlicensestarget = "Redeem Licenses"

}