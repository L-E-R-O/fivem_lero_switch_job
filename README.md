# 🔄 LERO Job Switch

> A lightweight and lightning-fast FiveM ESX resource that lets players seamlessly switch between their primary and secondary jobs! ✨

[![FiveM](https://img.shields.io/badge/FiveM-Resource-blue.svg)](https://fivem.net/)
[![ESX](https://img.shields.io/badge/Framework-ESX-ff69b4.svg)](https://github.com/esx-framework/esx-legacy)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Lua](https://img.shields.io/badge/Made%20with-Lua-blueviolet.svg)](https://www.lua.org/)

## 💝 What makes this special?

Hey there! 👋 This is a super simple but powerful resource that does one thing and does it really well - it lets your players switch between two jobs with just a command! No complicated menus, no confusing setups, just pure simplicity.

### ✨ Features

- 🚀 **Blazing Fast** - Optimized with smart caching for instant job switches
- 🎯 **Simple Command** - Just type `/jobswitch` and you're done!
- ⏱️ **Cooldown System** - Optional cooldown to prevent abuse
- 🎨 **ESX UI Integration** - Beautiful native ESX menu
- 📦 **Plug & Play** - Drop it in, configure it, and go!
- 🔧 **Fully Configurable** - Customize notifications, commands, and cooldowns
- 💾 **Database Optimized** - Smart caching reduces database queries
- 🐛 **Debug Mode** - Built-in performance monitoring

## 📋 Requirements

Before you get started, make sure you have:

- **ESX Legacy** - [Get it here](https://github.com/esx-framework/esx-legacy)
- **oxmysql** - [Get it here](https://github.com/overextended/oxmysql)
- A `job2` and `job2_grade` column in your `users` table (see installation below!)

## 📥 Installation

1. **Download** and extract the resource to your `resources` folder

2. **Add the database columns** (if you don't have them yet):
   ```sql
   ALTER TABLE `users` ADD COLUMN `job2` VARCHAR(50) DEFAULT 'unemployed';
   ALTER TABLE `users` ADD COLUMN `job2_grade` INT(11) DEFAULT 0;
   ```

3. **Add to server.cfg**:
   ```cfg
   ensure lero_jobswitch
   ```

4. **Restart your server** and you're all set! 🎉

## ⚙️ Configuration

Open `config.lua` and customize to your heart's content:

```lua
Config.Command = 'jobswitch'  -- The command players type
Config.Cooldown = 0           -- Cooldown in seconds (0 = disabled)
Config.Debug = false          -- Enable performance logs

-- Customize your notifications
Config.Notifications = {
    success = 'Job switched successfully!',
    noSecondJob = 'You don't have a second job!',
    cooldown = 'Please wait %s seconds!',
    error = 'Error switching jobs!'
}
```

## 🎮 Usage

It's super simple for your players:

1. Type `/jobswitch` in chat
2. A menu pops up showing their current and secondary job
3. Select the secondary job to switch
4. Done! They're now working their other job! 🎊

### For Developers

Want to trigger job switches from your own scripts? We got you covered:

```lua
-- Client-side export
exports['lero_jobswitch']:SwitchJob()

-- Server-side export
exports['lero_jobswitch']:SwitchPlayerJob(playerId)
```

## 🎯 Why Choose This?

- **Performance First** - Every millisecond counts! Built with caching and async operations
- **User Friendly** - Your players will love how easy it is to use
- **Maintainable** - Clean, well-commented code that's easy to customize
- **Reliable** - Tested and optimized for production servers

## 🤝 Support

Found a bug? Have a suggestion? Feel free to:
- Open an issue on GitHub
- Contribute with a pull request
- Give us a ⭐ if you like it!

## 📝 License

This project is licensed under the MIT License - feel free to use it on your server!

## 💖 Credits

Made with love by **LERO** 

---

<div align="center">
  
**Enjoy the resource? Drop a ⭐ star to show your support!**

*Happy job switching!* 🚀

</div>
