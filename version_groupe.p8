pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--sれたquence principale

-- au lancement
function _init()
create_player()
init_projectiles()
end
 
-- mise れき jour れき chaque frame (60 fois par secondes)
function _update60()
player_movement()
get_speed()
updt_projectiles()
end

-- affichage des sprites
function _draw()

--clear interface
cls()
--draw map on "left" corner
map(0,0,0,0)
--draw sprit number 1 at xy point
affichage_perso()



-- coin superieur g. camera
cam_x=0
cam_y=0

draw_projectiles()

end



-->8
--map

function check_flag(flag,x,y)
--recuperer flag sur la position
sprite=mget(x,y)
return fget(sprite,0)
end
-->8
--player

function create_player()
--on donne la position du sprite au depart
--puis la numero de sprite
perso={x=5,y=5,sprite=61}
end

function player_movement()
neox=perso.x
neoy=perso.y
	if (btn(❎)) then 
		shoot()
	end
	if (btn(⬆️)) then 
		neoy-=1
		dir="up"
	elseif ((btn(➡️))and(btn(⬆️))) then
		dir="diagoh_d"
	elseif (btn(➡️)) then 
		neox+=1 
		dir="right"
	elseif ((btn(➡️))and(btn(⬇️))) then 
		dir="diagob_d"
	elseif (btn(⬇️)) then 
		neoy+=1	
		dir="down"
	elseif ((btn(⬅️))and(btn(⬇️))) then 
		dir="diagob_g"
	elseif (btn(⬅️)) then 
		neox-=1 
		dir="left"
	elseif ((btn(⬅️))and(btn(⬆️))) then 
		dir="diagob_g"
	end
--condition si check-flag 
--renvoi true donc 0	
	if check_flag(0,neox,neoy)
		then --on avance pas 
		else --si pas de flag on avance
			perso.x=mid(0,neox,127)
			perso.y=mid(0,neoy,63)
	--la commande mid fait qu'une fois les intervalles depasser on revien a la valeur du milieu)
		end
	end
	
	function affichage_perso()
	--on cherche a faire avancer le sprite d'une case de 8px par une case
	spr(perso.sprite,perso.x*8,perso.y*8)
	end
-->8
--tirs

	function get_speed()

		if dir=="up" then
		speedx=0
		speedy=-1
		
		elseif dir=="diagoh_d" then
		speedx=1
		speedy=-1

		elseif dir=="right" then
		speedx=1
		speedy=0

		elseif dir=="diagob_d" then
		speedx=1
		speedy=1
		
		elseif dir=="down" then
		speedx=0
		speedy=1
		
		elseif dir=="diagob_g" then
		speedx=-1
		speedy=1

		elseif dir=="left" then
		speedx=-1
		speedy=0
		
		elseif dir=="diagoh_g" then
		speedx=-1
		speedy=-1
		end
	end

-- crれたe le tableau des projectiles qui est au dれたpart vide et sera rempli れき chaque tir
function init_projectiles()
	projectiles={}
end

-- fonction appelれたe quand le joueur tire
function shoot()

    -- crれたe une variable temporaire qui prends en compte la position actuelle du joueur
	local new_projectile={
		-- neox est une valeur en pixels, on multiplie par 8 pour avoir une valeur en cases
		
		x=neox*8,
		y=neoy*8,
		neospeedx=speedx,
		neospeedy=speedy,
		
		}
-- on ajoute ce projectile qu'on vient de crれたer dans le tableau des projectiles
add(projectiles,new_projectile)
end

-- fait se dれたplacer le projectile en temps rれたel
function updt_projectiles()
	-- pour tous les projectiles dans le tableau
	for proj in all(projectiles) do
	 -- regarde l'orientation au moment du tir pour savoir dans quelle direction le projectile part
		proj.x=proj.x+proj.neospeedx
		proj.y=proj.y+proj.neospeedy
	

		-- supprime le projectile si il sort des bords de la map,
		-- car sinon ils ne disparaissent jamais et deviennent tellement nombreux qu'ils ralentissent le jeu
		if (proj.x<-8 or proj.y<-8) then del(projectiles, proj)
		
		end
	end
	end

-- affiche le sprite du projectile	
function draw_projectiles()
	-- pour tous les projectiles du tableau
	for proj in all(projectiles) do
		-- aficher la sprite num. 128 aux coordonnれたes x et y du projectile
		spr(128,proj.x,proj.y)
	end
end


__gfx__
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555444444444444444444444444
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555444444444444444444444444
00700700555555555555555555555555555555555555555555555555555555555555555555566055555555555555555555555555440000000000000000000044
00077000555555555566055555555555555555555560555555555555555555555555555555555605555555555556605555555555440555555555555555555544
00077000555555555655605555555555555555555656055555555555555555555555555555555555555555555565560555555555440555555555555555555544
00700700555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440556055555555555555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440565605555555555555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440555555555555555555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440555550000000055555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440555550000000055555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555566055555555555555555555440555550000000055555544
00000000555555555555555555555555556055555555555555555555555555555555555555555555655660555555555555555555440555550000000055555544
00000000555555555556660555555555565555555555555555555555555555555555555555555555555556055555555555555555440555550000000055555544
00000000555555555565560555555555555555555555555555555555555566055555555555555555555555555555555555555555440555550000000055555544
00000000555555555655556055555555555555555555555555555555555655605555555555555555555555555555555555555555440555550000000055555544
00000000555555555555555555555555555555555555555555555555556555555555555555555555555555555555555555555555440555550000000055555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440555555555555555555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440555555555555556605544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555440555555555555555560544
00000000555555555555555555555555555666055555555555555555555555555555555555555555555555555555555555555555440555555555555555555544
00000000555555555555555555555555556555605555555555555555555555555556055555555555555555555555555555660555440555555555555555555544
00000000555555555555555555555555555555555555555555555555555555555555660555555555555555555555555556656555440555555555555555555544
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555444444444444444444444444
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555444444444444444444444444
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555000000000000000000000000
00000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555000000000000000000000000
00000000555555555555555555555555555555555555555555566055555555555555555555555555555555555555555555555555000fff000000000000000000
0000000055605555555555555555555555555555555555555565560555555555555555555555555555555555555555555555555500f0f0f00000000000000000
0000000056560555555555555555555555555555555555555655555555555555555555555555555555556605555555555555555500f0f0f00000000000000000
00000000555555555555555555555555555555555555555555555555555555555555555555555555556655605555555555555555f00f0f0f0000000000000000
000000005555555555555555555555555555555555555555555555555555555555555555555555555655555555555555555555550fffffff0000000000000000
0000000055555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555500fffff00000000000000000
05605605605605440555555555555544444444440000000000000000000000000000000000000000000000000000000000900000000000000000000000000000
05605605605605440555555555555544444444440000000000000000000000000000000000000000000000000000000999000000000000000000000000000000
05005005005005000555555555555500444444440000000000000000000000000000000000000000000000000000009aa9000000000000000000000000000000
55555555555555555555555555555555444444440000000000000000000000000000000000000000000000000000006666000000000000000000000000000000
55555555555555555555555555555555444444440000000000000000000000000000000000000000000000055555555665555555000000000000000000000000
55555555555555555555555555555555444444440000005555555555555555555555555555555555555555544444444444444444555555555555555555555555
55555555555555555555555555555555444444440000055444544454445444544454445444544454445444455555555555555555445444544454445444544454
55555555555555555555555555555555444444440000054555555555555555555555555555555555555555550600600600600605555555555555555555555555
55555555555555555555555555555555000000000000054544544454445444546666666644544454445495450600600600600605445944544454448444544454
55555555555555555555555555555555000000000000055544544454445444546000000644548454445449950600600600600605499444544484488444766654
5555555555555555555555555555555500000000000005455555555555555555666666665585585555559a9506006006006006055a9555555885555557000065
55555555555555555555555555555555000000000000054545444544454445446000000645448884454446450600600600600605464445444588458446000064
5555555555555555555555555555555500000000000005454544454445444544666666664548888445444645060060060060060546444544488845444600b064
54444444444444445444444444444444000000000000055555555555555555556000000655885858555555550600600600600605555555555585555556bbbb65
444444444444444444444444444444440000000000000545445444544454445466666666485848544454454506006006006006054454445444844454446b6b54
440560560560560544055555555555550000000000000545445444544454445444544454445448544454454506006006006006054454445444544454445b4b54
00000000000000000000000000000000000000000000054555555555555555555555555555555555555555550600600600600605555555555555555555bbbb55
000000000000000000000000000000000000000000000555000000000000000000000000088000000000000000000000000000000000000000000000bbbb0000
000000000000000000000000000000000000000000000545000000000000000000000000000080000000000000000000000000000000000000000000000bb000
00000000000000000000000000000000000000000000054500000000000000000000000000000000000000000000000000000000000000000000008000000000
00000000000000000000000000000000000000000000054500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000055500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000054500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000054500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004554554400000000445494540000000011111111000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004454455400000000449944540000000011111111000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004454454500000000559a95550000000011111111000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005455454400000000454645440000000011111111000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004554554400000000454645440000000011111111000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004454455400000000555555550000000011111111000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004454454500000000445444540000000011111111000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005455454400000000445444540000000011111111000000000000000000000000
08008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000001010100000000000000000000000000010001000000000000000000000000000101010000000000000000000000000000000002020404000000000200000000000000020204040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0d0e0e40410e0e0f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d0102031c051c1f00000045464747474b4c4748484800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d0719142c07071f000000555656595a5b5c5d56565f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1c1c07072c0b1f00000065666669666b6c6666666f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d311207191c071f000000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d011c1c073a191f000000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d2c1c361c1c191f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2d2e2e50512e2e2f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
