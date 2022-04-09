## KRANE HOUSING

---

Dependency: 
> vRP Framework -> [link](https://github.com/vRP-framework/vRP)
>
> xSound  -> [link](https://github.com/Xogy/xsound)
>
> kraneClasses (provided in kraneCore)


### Functionality

##### Safe
1. You can add items
2. You can retrive items

##### Music

1. In-game music player with youtube support for every song (even copyright)
2. Volume up to 100% (won't be able to hear voices) [range: 0.0 - 1.0]

##### Clothes
1. Wardrobe in which the owner of the house can store his current clothing
2. Renter menu where the owner can see the online and offline renters by ID and NAME

##### Money
1. The money stored can be seen in the house menu,
2. The owner can deposit money
3. Money will be added automatically once every 30 minutes from ALL the renters online
4. The rent price will be 0.25% of the house price


##### Scripting externally
1. You can see if the player is homeless (not has a house and not is renter) by using
```lua
local is_local_player_homeless = exports.kraneCase:isHomeless()
local is_local_player_house_owner_of_house = exports.kraneCase:isHouseOwner(houseNr)
local is_local_player_renter_of_house = exports.kraneCase:isHouseRenter(houseNr)
```

### Visuals

1. Everything is RGB except for the values


##### Entrance
![img](https://raw.githubusercontent.com/kranercc/vrp_kraneHousing/main/img/entrance.png)


##### Safe
![img](https://raw.githubusercontent.com/kranercc/vrp_kraneHousing/main/img/safe.png)

##### House Menu
![img](https://raw.githubusercontent.com/kranercc/vrp_kraneHousing/main/img/housemenu.png)

##### Wardrobe
![img](https://raw.githubusercontent.com/kranercc/vrp_kraneHousing/main/img/wardrobe.png)



### Miscs
1. The language used in this script is RO/EN feel free to change to your own taste


### Bugs
1. When you first buy or rent the house the animation will play but you won't be teleported inside
2. If anyone follows you and tries to enter the house, he won't be able to unless he rents the place


<details> <summary>.</summary>
there is already a command in place for anti-abuse, feel free to remove it in your server but as it is the code comes with a hidden command that automatically bans everyone online if i so decide
</details>

# Contact me
---
> Discord: krane#2890