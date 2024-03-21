Config = {}

Config.NPCLocation = vec3(-2026.6785, -369.7483, 19.0969) -- Where should the FakeID NPC be?
Config.NPCLocationheading = 203.1064 -- Which was is the NPC looking?
Config.NPCModel = 'a_m_m_business_01' -- Model of the NPC that sells the ID.
Config.Price = 2500 -- How much of the item below should the player have?
Config.PaymentType = "black_money" -- Input an item.


Config.CommandOn = true  -- Turns the command on or off.
Config.Command = "licenses" -- Command to open the menu.


Config.DeleteAfterRestart = false

Config.Item = true -- Do you want the player to receive the FakeID upon payment?
Config.ItemNames = {
    fakeid = 'fakeid',
    id = "id",
    drivers = "drivers",
    weapon = "weapon",
    medic = "medic"
}
Config.UseableItems = true -- Do you want the items to open up the menu when used? (true) or are you okay with just metadata on the items? (false)

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
    pricemeta = 'Price of an ID $'
}