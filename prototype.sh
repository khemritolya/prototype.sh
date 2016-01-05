#!/bin/bash

#
# (c) Khemri Tolya 2015-01-02
#
# This is the (unabridged) source to Prototype (it is the source file)
#
# Prototype is a game about prototypes. This is a very descriptive
# description.
#													

enemies[0]="Troll"
enemies[1]="Goblin"
enemies[2]="Dragon"
enemies[3]="Demonic Goat"
enemies[4]="John Cena"
enemies[5]="Wyvren"
enemies[6]="Mummy"
enemies[7]="Old Man"
enemies[8]="Mimic"
enemies[9]="Bat"
enemies[10]="Clown"
enemies[11]="Mighty Demon"
enemies[12]="Rogue"
enemies[13]="Mad King"
enemies[14]="Orc"
enemies[15]="< Angry Developer >"

clear
echo " [X ----- X ------ X] ------ [ Welcome to Prototype ] ----- [X ----- X ----- X] "
echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
echo "                             [         PLAY         ]"
echo;echo;echo;echo;echo
echo -n "Press [ ENTER ] to play or enter RELOAD and press [ ENTER ] to reload the game. "
read temp
if [ "$temp" == "RELOAD" ];
then																
	echo -n "Enter a new name: "
	read name
	printf "$name\n1\n10\n2\n2" > character.txt
fi
quit=0
while [ $quit == 0 ];
do
clear
if [ -f "character.txt" ];
then																
	clear
	echo -n "Loading..."
else
	clear
	echo -n ""
	read name
	printf "$name\n1\n10\n2\n2\n" > character.txt
	echo -n "Loading..."
fi
name=$(sed -n '1p' character.txt)												
char_lvl=$(sed -n '2p' character.txt)
char_health=$(sed -n '3p' character.txt)
char_atk=$(sed -n '4p' character.txt)
char_def=$(sed -n '5p' character.txt)
echo "Done"
clear
echo "Your Prototype:"
echo " [X ----- X ------ X] ------ [X ----- X -- X ----- X] ----- [X ----- X ----- X] "
echo "Name: $name"
echo "Level: $char_lvl"														
echo "Health: $char_health"
echo "Attack: $char_atk"
echo "Defense: $char_def"
echo " [X ----- X ------ X] ------ [X ----- X -- X ----- X] ----- [X ----- X ----- X] "
echo "Options:"
echo "[1] Delve"
echo "[2] Quit"
read option
if [ "$option" == "1" ] || [ "$option" == "Delve" ] || [ "$option" == "delve" ];
then																
	echo "You delve into the Dungeons..."
	quit_delve=0
	override=1
	while [ $quit_delve == 0 ];
	do
		clear
		if [ $override == 1 ];
		then
			c_en_lvl=$RANDOM
			c_en_lvl=$[ ( $c_en_lvl % 3 ) - 1 + $char_lvl ]
			c_en_id=$RANDOM
			c_en_id=$[ $c_en_id % 16 ]
			c_en_health=$RANDOM
			c_en_health=$[ $c_en_health % ( 10 * $c_en_lvl + 1) + 1 ]							
			c_en_atk=$RANDOM
			c_en_atk=$[ $c_en_atk % ( 2 * $char_def ) + 1]
			c_en_def=$RANDOM
			c_en_def=$[ $c_en_def % ( 2 * $char_atk ) ]
			override=0
		fi		
		echo "Your run into a ${enemies[$c_en_id]}"
		echo "Level: $c_en_lvl"		
		echo "Heath: $c_en_health"
		echo "Attack: $c_en_atk"
		echo "Defense: $c_en_def"
		echo -n "What do you do? "											
		read action
		if [ "$action" == "quit" ] || [ "$action" == "Quit" ];
		then
			echo "You try to run away..."
			if [ $char_lvl -le $c_en_lvl ];
			then												
				echo "You run away, unscathed!"
				sleep 2
			else
				char_health=$[ $char_health - $c_en_lvl ]
				echo "You run away, but lose $c_en_lvl HP!"
				echo "You now have $char_health HP!"
				sleep 2
			fi
			if [ $char_health -le 0 ];
			then
				echo "You try to escape, but are killed on your way."
				exit -1
			else
				echo "You run out of the Dungeons, unsure if anything has followed you..."
				sleep 2		
			fi
			
			quit_delve=1
		else
			if [ "$action" ==  "run" ] || [ "$action" == "Run" ];
			then
				echo "You try to run away..."
				if [ $char_lvl -le $c_en_lvl ];
				then												
					echo "You run away, unscathed!"
					sleep 2
				else
					char_health=$[ $char_health - $c_en_lvl ]
					echo "You run away, but lose $c_en_lvl HP!"
					echo "You now have $char_health HP!"
					sleep 2
					
				fi
				override=1
			else
				if [ "$action" == "attack" ] || [ "$action" == "Attack" ];
				then
					echo "You attack!"
					if [ $char_atk -gt $c_en_def ];
					then
						c_en_health=$[ $c_en_health - $char_atk + $c_en_def ]
						echo "You dealt $char_atk damage!"
					else
						c_en_health=$[ $c_en_health - 1 ]
						echo "You dealt 1 damage!"
					fi
					if [ $c_en_health -le 0 ];
					then
						echo "You deafeated a ${enemies[$c_en_id]}"
						echo "You gain a level!"
						char_lvl=$[ $char_lvl + 1]
						echo -n "You may add 10 to ATK or DEF: "			
						read a_or_d
						if [ "$a_or_d" == "ATK" ] || [ "$a_or_d" == "atk" ] || [ "$a_or_d" == "attack" ] || 								[ "$a_or_d" == "Attack" ];
						then
							echo "Adding 10 to ATK"
							char_atk=$[ $char_atk + 10 ]
						else
							echo "Adding 10 to DEF."
							char_def=$[ $char_def + 10 ]
						fi
						echo "Healing..."
						char_health=10
						echo "Saving..."
						printf "$name\n$char_lvl\n$char_health\n$char_atk\n$char_def\n" > character.txt
						echo "Your Prototype:"
						echo " [X ----- X ------ X] ------ [X ----- X -- X ----- X] ----- [X ----- X ----- X] "
						echo "Name: $name"
						echo "Level: $char_lvl"		
						echo "Health: $char_health"
						echo "Attack: $char_atk"
						echo "Defense: $char_def"
						echo " [X ----- X ------ X] ------ [X ----- X -- X ----- X] ----- [X ----- X ----- X] "
						sleep 10
						override=1
					else
						if [ $char_def -lt $c_en_atk ];
						then
							char_health=$[ $char_health - $c_en_atk + $char_def ]
							echo "You took $c_en_atk damage!"
						else
							char_health=$[ $char_health - 1 ]
							echo "You took 1 damage!"
						fi
						if [ $char_health -le 0 ];
							then
							echo "You died!"
							sleep 10
							exit -1
						else
							echo "You now have $char_health HP"
							override=0
						fi	
					fi
					if [ $char_health -le 0 ];
					then
						echo "You died!"
						sleep 10
						exit -1
					fi
					sleep 2
				else				
					echo "Unknown Command!"
					sleep 2
				fi
			fi	
		fi
	done															
else
	if [ "$option" == "2" ] || [ "$option" == "quit" ] || [ "$option" == "Quit" ];
	then
		echo "Quitting...!"
		quit=1
		sleep 1
	else
		echo "Unknown Command"
		sleep 2
	fi
fi
done
