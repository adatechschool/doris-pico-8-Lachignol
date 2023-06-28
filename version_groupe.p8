pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

-- sequence principale

-- au lancement
function _init()
 _update = menu_update
 _draw = menu_draw
	init_ennemis()
	make_ennemi(5, 8, 8)
	create_player()
	init_projectiles()
	text_setup()
	add_text(23, 8, "Vous avez rammassé une clef")
end
 
-- mise a jour a chaque frame (60 fois par secondes)
function game_update()
	if(not active_text) then
	player_movement()
	get_vecteur()
	updt_projectiles()
	update_camera()
	move_ennemis()
	update_enemis()
	--collisions()

	-- pour quitter le message
	else if (btnp(q)) extcmd("reset")

	-- pour quitter le message
	else if (btnp(q)) extcmd("reset")
	end
end

-- affichage des sprites
function game_draw()

	-- nettoyer l'interface
	cls()

	-- afficher la map
	draw_map()

	-- afficher personnages, projectiles et UI
	affichage_perso()

	draw_ennemis()

	draw_projectiles()
	
	draw_ui()
	draw_text()
end

function menu_draw()
 map(33,0,0,0,16,16)
 print("press x+c",50,90,7)
end

function menu_update()
 if (btn(❎)) and (btn(🅾️)) then
 -- changer de scene
  _update = game_update
  _draw = game_draw
 end 
end



-->8
-- map

function draw_map()
	map(0,0,0,0,128,64)
end

-- recuperer flag sur la position
function check_flag(flag,x,y)

	-- recuperer le numero de sprite
	local sprite = mget(x,y)

	-- retourner un booleen qui indique si le drapeau est present sur la sprite
	return fget(sprite,flag)
end



//--function camera piece update_camera()
-- camx=flr(perso.x/16)*16
-- camy=flr(perso.y/16)*16
-- camera(camx*8,camy*8)
-- end

-- recentre la camera
function  update_camera()

	-- retourne la valeur du milieu lorsqu'une valeur min/max est atteinte
	camx = mid(0, perso.x-8, 31-15) --(? notion des point et virugule)
	camy = mid(0, perso.y-8, 31-15)

	-- centre la camera avec un * 8 pour passer d'une valeur en pixels a une valeur en case
	camera(camx * 8, camy * 8)
end

-- change la sprite quand la clef est ramasser
function replace_sprite_key(x, y)

	-- recuperer le numero de sprite
	sprite = mget(x, y)

	-- changer la sprite pour la sprite suivante a la position 
	mset(x, y, sprite+1)
end


---- EN CHANTIER ----
function replace_sprite_door(x, y)
	sprite = mget(x,y)
	if check_flag(2, 14,10) then
	mset(12, 10, 76)
	mset(12, 11, 92)
	mset(12, 12, 108)
	mset(12, 13, 124)
	mset(13, 10, 77)
	mset(13, 11, 93)
	mset(13, 12, 109)
	mset(13, 13, 125)
	mset(14, 10, 78)
	mset(14, 11, 94)
	mset(14, 12, 110)
	mset(14, 13, 126)
	mset(15, 10, 79)
	mset(15, 11, 95)
	mset(15, 12, 111)
	mset(15, 13, 127)
	end
end
	
---- EN CHANTIER ----


function pick_up_key(x, y)

	-- remplacer la clef posee au sol par une case sol vide
	replace_sprite_key(x, y)

	-- incrementer le compteur de clees
	perso.keys+=1
end

function open_door(x, y)
	replace_sprite_door(x, y)

	-- decrementer le compteur de clef
	perso.keys-=1
	-- on peux rajouter sfx(num) son
end


-->8
-- player

function affichage_perso()

	-- on cherche a faire avancer le sprite d'une case de 8px par une case
	spr(perso.sprite, perso.x*8, perso.y*8)
end
	
	

function create_player()
	
--on donne la position du sprite au depart
--puis la numero de sprite
--puis initialisation du compteur de clef
	perso={
		x=5,
		y=5,
		sprite=61,
		keys=0,
		cooldown
	}
end
   

function player_movement()

	-- on recupere la position du joueur
	neox = perso.x
	neoy = perso.y

	-- si X est pressee
	if (btn(❎)) then 
		-- on cree un projectile
		shoot()
	end
	
	-- mouv. selon touche pressee
	if (btn(⬆️)) then 
		neoy -= 1
		dir = "up"

	elseif ((btn(➡️))and(btn(⬆️))) then
		dir = "diagoh_d"

	elseif (btn(➡️)) then 
		neox += 1 
		dir = "right"

	elseif ((btn(➡️))and(btn(⬇️))) then 
		dir = "diagob_d"

	elseif (btn(⬇️)) then 
		neoy += 1	
		dir = "down"

	elseif ((btn(⬅️))and(btn(⬇️))) then 
		dir = "diagob_g"

	elseif (btn(⬅️)) then 
		neox -= 1 
		dir = "left"

	elseif ((btn(⬅️))and(btn(⬆️))) then 
		dir = "diagob_g"
	end
	
	-- si on passe sur une case avec un objet, on le recupere
	interact(neox, neoy)
	
	-- on verifie que la case n'a pas de flag qui indiquerai qu'elle est infranchissable
	if not check_flag(0, neox, neoy) then
		perso.x = mid(0, neox, 127)
		perso.y = mid(0, neoy, 63)
	end
end

-- fonction pour interagir avec les objets
function interact(x, y)

	-- si un flag indique la presence d'une clef
	if check_flag(1, x, y) then

	-- on la ramsse
	pick_up_key(x, y)
	
	-- sinon, si le flag indique une porte
--flag 2 pour les portes
	elseif check_flag(2, x, y)

	-- et que le joueur a des clefs
	and perso.keys > 0 then

	-- la porte s'ouvre
	open_door(x, y)
	end

	--flag 3 pour le texte
	if check_flag(3, x, y)
		then active_text=get_text(x,y)
	end
end
-->8
-- ennemis

-- cree un tableau vide pour les ennemis
function init_ennemis()
	ennemis = {}
end

-- creer ennemis avec
-- num. de sprite
-- position
-- ?
function make_ennemi(sprite, x, y)
	local new_ennemi = {
	sprite = sprite,
	x = x,
	y = y,
	dx = 1,
	dy = 1,
	tag = 1,
	box = {x1 = 1, y1 = 1 , x2 = 6, y2 = 6}
	}

	add(ennemis, new_ennemi)
end

-- deplacement ennemis
function move_ennemis()

	-- pour chaque ennemi
	for a in all(ennemis) do

		-- si l'ennemi est a moins de 8 cases du perso en x
		if ((perso.x - a.x) < 8) or ((perso.x - a.x) > -8) then

			-- si le perso est sur une case de pos. x plus eleve
			 if (perso.x > a.x) then
				-- on incremente la position cible de l'ennemi
				e_neox = a.x + (1/10)
				
			-- si la case a une pos. x moins eleve
			elseif (perso.x < a.x) then

				-- on decremente
				e_neox = a.x - (1/10)
			else 

				-- sinon, on garde le mれちme angle
				e_neox = a.x
			end
		end			

		-- meme logique pour y
		if ((perso.y - a.y) < 8) or ((perso.x - a.y) > -8) then

			if (perso.y > a.y) then
				e_neoy = a.y + (1/10)

			elseif (perso.y < a.y) then
					e_neoy = a.y - (1/10)

			else 
				e_neoy = a.x
			end
		end
		

		-- si la position suivante n'est PAS un mur (flag 0)
		if not check_flag(0, e_neox, e_neoy)
		then 

			-- avancer normalement
			a.x = e_neox
			a.y = e_neoy
		else
			-- si c'est un mur
			while check_flag(0, e_neox, e_neoy) do
				-- on genere des positions cibles aleatoires entre -1 et 1
				randx = ((rnd(3)) -1)
				randy = ((rnd(3)) -1)
				
				-- on actualise la valeur de e_neox et e_neoy et on regarde si れせa passe
				e_neox = a.x + randx

				e_neoy = a.y + randy
			end

			-- une fois qu'on a trouvれた une valeur qui marche, on y va
			a.x = e_neox
			a.y = e_neoy
		end
	end
end

   -- dessiner ennemis
function draw_ennemis()

	-- pour tous les ennemis
	for a in all(ennemis) do
		
		-- on rends le bleu clair transparent pour avoir un fond transparent
		palt(12, true)

		-- on rend le noir opaque pour afficher le contour du sprite
		palt(0, false)

		-- on affiche le sprite en passant de pixels a cases
		spr(a.sprite, a.x * 8, a.y * 8, 2, 2) 

		-- on retabli la transparence par defaut 
		palt()
	end
end

-->8
--collisions

-- creer des boxs
function get_box(a)

	local box = {}
	box.x1 = a.x+a.box.x1
	box.y1 = a.y+a.box.y1
	box.x2 = a.x+a.box.x2
	box.y2 = a.x+a.box.y2

	return box
end

-- verifier si collisions
function check_coll(a,b)

	if (a == b or a.tag == b.tag) return false
	local box_a = get_box(a)
	local box_b = get_box(b)

	if (box_a.x1 > box_b.x2 or
	box_a.y1 > box_b.y2 or
	box_b.x1 > box_a.x2 or
	box_b.y1 > box_a.y2) then
		return false
	else
		return true
	end
end

-- collisions
function collisions()
	for a in all(ennemis) do
			if (check_coll(a,b) == true) then
				del(ennemis,a)
			end
	end
end

-->8
--tirs

function get_vecteur()

	if dir == "up" then
		vecteurx = 0
		vecteury = -1
	
	elseif dir == "diagoh_d" then
		vecteurx = 1
		vecteury = -1

	elseif dir == "right" then
		vecteurx = 1
		vecteury = 0

	elseif dir == "diagob_d" then
		vecteurx = 1
		vecteury = 1
	
	elseif dir == "down" then
		vecteurx = 0
		vecteury = 1
	
	elseif dir == "diagob_g" then
		vecteurx = -1
		vecteury = 1

	elseif dir == "left" then
		vecteurx = -1
		vecteury = 0
		
	elseif dir == "diagoh_g" then
		vecteurx = -1
		vecteury = -1

	-- par dれたfaut, orientation vers le bas
	else
		vecteurx = 0
		vecteury = 1
	end
end

-- creation du tableau des projectiles qui est au depart vide et sera rempli a chaque tir
function init_projectiles()
	projectiles = {}
end

-- fonction appelee quand le joueur tire
function shoot()

-- creation d'une variable temporaire qui prends en compte la position actuelle du joueur
	local new_projectile = {
-- neox est une valeur en pixels, on multiplie par 8 pour avoir une valeur en cases
		x = neox * 8,
		y = neoy * 8,
		neovecteurx = vecteurx * 4,
		neovecteury = vecteury * 4,
		}

-- on ajoute ce projectile qu'on vient de creer dans le tableau des projectiles
	add(projectiles, new_projectile)
end

-- fait se deplacer le projectile en temps reel
function updt_projectiles()

	-- pour tous les projectiles dans le tableau
	for proj in all(projectiles) do

	if check_flag(0, flr(proj.x + proj.neovecteurx), flr(proj.y + proj.neovecteury))
		then 
			
			
			del(projectiles, proj)
		else
		-- regarde l'orientation au moment du tir pour savoir dans quelle direction le projectile part
		proj.x = proj.x + proj.neovecteurx
		proj.y = proj.y + proj.neovecteury
	

		-- supprime le projectile si il sort des bords de la map,
		-- car sinon ils ne disparaissent jamais et deviennent tellement nombreux qu'ils ralentissent le jeu
		end
	end
end

-- affiche le sprite du projectile	
function draw_projectiles()

	-- pour tous les projectiles du tableau
	for proj in all(projectiles)
	do
		-- aficher la sprite du projectile aux coordonnees
		spr(2, proj.x, proj.y)
	end
end
-->8

-- affichage de l'ui
function draw_ui()
	-- recentrage de la camera
	camera()

	-- transparence des couleurs
	palt(0, false)
	palt(12, true)

	-- afficher la sprite des clefs
	spr(3, 2, 2, 2, 2)

	-- reset transparence
	palt()

	-- afficher le compteur de clefs
	print_outline("x".. perso.keys, 20, 4)
end


-->8
-- interactions

function interact2()

	--  j'ai tente des trucs mais jy comprends plus rien
	if (dir_vector_x) and (dir_vector_y) then

		object_x = (perso.x + dir_vector_x)
		object_y = (perso.y + dir_vector_y)
	
	else 
		object_x = (perso.x + 1)
		object_y = (perso.y - 1)
	end

	if (btnp(e)) then
		if (check_flag(2,(object_x),(object_y)))
			then
			mget(object_x, object_y)
			fset(sprite, 0, false)
		end
	end
end

-- fonction pour afficher quelquechose avec du contour
function print_outline(text, x, y)
	print(text, x-1, y, 0)
	print(text, x+1, y, 0)
	print(text, x, y-1, 0)
	print(text, x, y+1, 0)
	print(text, x, y, 7)
end

-->8
--text code

function text_setup()
-- differents texte a ajouter
	texts = {}
	


end

function add_text(x, y, message)
	texts[x+y*128] = message
end

function get_text(x,y)
	return texts[x+y*128]
end

function draw_text()
-- affiche le text en fonction de la position perso
	if (active_text) then
	textx = camx * 8 + 4
	texty = camy * 8 + 48

	rectfill(textx,texty,textx+119,texty+31,7)
	print(active_text,textx+4,texty+4,1)
-- message pour indiquer bouton de sortie de l'ecran texte
	print("haut pour fermer",textx+4,texty+23,6)
end
-- mis en place du bouton de sortie 
	if (btnp(q))then 
	active_text = nil
end
end

__gfx__
000000000000000000000080ccccccccc000cccccccccccccccc00cccccccccccccc000000cccccccccccccc5555555555555555444444444444444444444444
000000000000ee0000000000cccccccc0a990cccccccccccccc0ee0cccccccccccc06666660ccccccccccccc5555555555555555444444444444444444444444
0070070000eeeee000888800ccccccc0a94990cccccc0000ccc0880ccccccccccc0666666660cccccccccccc5555555555555555440000000000000000000044
0007700000e0e0e000888880cccccc0a9404990cccc0eeee0ccc00cccccccccccc0666666660cccccccccccc5556605555555555440555555555555555555544
000770000eeeeeee08888880cccccc0940c0490ccc0eeeeee00ccccccccccccccc0666666660cccccccccccc5565560555555555440555555555555555555544
00700700eeeeeeee00088800cccccc099404940ccc0eeeeeeee00ccccccccccccc0666666660cccccccccccc5555555555555555440556055555555555555544
000000000000000080888800cccccc09994940ccc0ee77eeeeeee0ccccc00cccccc066666660cccccccccccc5555555555555555440565605555555555555544
000000000000000000000008ccccc0a949940cccc0e7067ee77ee0cccc0660cccccc06666600cccccccccccc5555555555555555440555555555555555555544
000000005555555555555555cccc0a940000ccccc0eeeeee7067ee0cc060060c0cccc006666600cccccccccc5555555555555555440555550000000055555544
000000005555555555555555ccc0a940cccccccc0ee76eeeeeeeee0ccc00c06060c0066666666600cccccccc5555555555555555440555550000000055555544
000000005555555555555555cc0a940ccccccccc0ee767eee76eeee0cc0600660c066666666666660ccccccc5555555555555555440555550000000055555544
000000005555555555555555c0a94040cccccccc0eeee776776eee80c0676660c06666666666666660cccccc5555555555555555440555550000000055555544
0000000055555555555666050a940c0ccccccccc088eee767eeee880cc0606660666666666666666660ccccc5555555555555555440555550000000055555544
000000005555555555655605c04040ccccccccccc0088eeeeeee800cccc0066666666666666666666660cccc5555555555555555440555550000000055555544
000000005555555556555560cc040cccccccccccccc0088888880cccccccc006666606666666660666660ccc5555555555555555440555550000000055555544
000000005555555555555555ccc0ccccccccccccccccc0000000ccccccccccc0666006666666660066660ccc5555555555555555440555550000000055555544
00000000555555555555555544440004444444445555555555555555cccccccc000cc066666660cc06660ccc5555555555555555440555555555555555555544
00000000555555555555555540007aa0444444445555555555555555cccccccccccccc0666660ccc0660cccc5555555555555555440555555555555556605544
00000000555555555555555507aaa0a0444444245555555555555555ccccccccccccc066666660cc0660cccc5555555555555555440555555555555555560544
0000000055555555555555550a909990444444025555555555555555cccccccccccc0666666660cc0660cccc5555555555555555440555555555555555555544
00000000555555555555555540040004444444405555555555555555ccccccccccc06666666666006660cccc5555555555660555440555555555555555555544
00000000555555555555555544444444444444445555555555555555cccccccccc066666666666066660cccc5555555556656555440555555555555555555544
00000000555555555555555522222222222222225555555555555555ccccccccc0666666066666066660cccc5555555555555555444444444444444444444444
00000000555555555555555500000000000000005555555555555555ccccccccc0666660c06666006660cccc5555555555555555444444444444444444444444
00000000555555555555555555555555555555555555555555555555cccccccc0666660ccc066660000ccccc5555555555555555000000000000000000000000
00000000555555555555555555555555555555555555555555555555cccccccc066660cccc066660cccccccc5555555555555555000000000000000000000000
00000000555555555555555555555555555555555555555555566055cccccccc06660cccccc066660ccccccc5555555555555555000fff000000000000000000
00000000556055555555555555555555555555555555555555655605ccccccccc0660ccccccc06660ccccccc555555555555555500f0f0f000a0000000000000
00000000565605555555555555555555555555555555555556555555ccccccccc0660ccccccc06660ccccccc555555555555555500f0f0f00a0aaaaa00000000
00000000555555555555555555555555555555555555555555555555cccccccc06660cccccccc06660cccccc5555555555555555f00f0f0f00a00a0a00000000
00000000555555555555555555555555555555555555555555555555ccccccc0666660cccccc0666660ccccc55555555555555550fffffff0000000000000000
00000000555555555555555555555555555555555555555555555555cccccc0666660cccccccc0666660cccc555555555555555500fffff00000000000000000
00000000000000000000000000000000000000000000000000000000009000007770777777777777777777777777707777707777777777777777777777777077
00000000000000000000000000000000000000000000000000000009990000007660776767766666666666676766706776607767677666666666666767667067
0000000000000000000000000000000000000000000000000000009aa90000007670767676666666666666667677706776707676766666666666666676777067
00000000000000000000000000000000000000000000000000000066661000007760777777777777777777777777707777607777777777777777777777777077
00000000000000000000000000000000000000000000000555555556615555556660666666666666666666666666606666606666666666666666666666666066
00000000000000000000000055555555555555555555555fffffffffffffffff666100000000000000000000000001d6666100000000000000000000000001d6
000000ff4454445444544454ff5fff5fff5fff5fff5ffff51111111111111115666d1000000000000000000000001d6d666d1000000000000000000000001d6d
000000f5ff5fff5f555555555555555555555555555555550d00d00d00d00d05dddd1000000000000000000000001ddddddd1000222220002222222222001ddd
000000ff245444544454445466666666d4544454445495450d00d00d00d00d051110000000000000000000000000001111100000222220002222222222200011
00000050225444544454445460000006d4548454445449950d00d00d00d00d056666100000000000000000000000161666661022222440002424422242201616
000000ff115555555555555566666666d585585555559a950600600600600605d6dd1000000000000000000000001616d6dd1024422244024244442444201616
000000ff212445444544454460000006d54488844544464506006006006006056ddd1000000000000000000000001d1d6ddd1042444024044444440224401d1d
000000ff212245444544454466666666d5488884454446450600600600600605dddd1000000000000010000000001d1ddddd1044444444044444444004401d1d
00000050111155555555555560000006d5885858555555550600600600600605dddd1000000000011011000000001d1ddddd1044444442044444444404401d1d
000000ff221224544454445466666666d8584854445445450600600600600605d1d1100000100010111010100000110dd1d1102222222000222222220220110d
000000ff221222122212221222122212241448144454454506006006006006051110000001001101111111011000000011100000000000000000000000000000
000000ff111111111111111111111111111111115555555506006006006006056666100111110011111111111100166666661044444444444000444444401666
0000005000000000000000000000000008800000000000000000000000000000d6dd1000101111011111111101101dddd6dd1044444444444404444444401ddd
000000ff00000000000000000000000000008000000000000000000000000000dddd1011011111115515115511101ddddddd1044444444244204444444401ddd
000000ff00000000000000000000000000000000000000000000000000000000dddd1010111151555155155110101ddddddd1044444444024004442244401ddd
000000ff00000000000000000000000000000000000000000000000000000000dddd10101155151555515151510011d1dddd10444444444044044200444011d1
0000005000000000000000000000000000000000000000000000000000000000ddd11001151555ddd5d555d551101d11ddd11044444444444202444444401d11
000000ff00000000000000000000000000000000000000000000000000000000111110115555dddd5ddddddd5510111011111022222222222000222222201110
000000ff0000000000000000000000000000000000000000000000000000000000000011155ddddddddd666d5150000000000000000000000000000000000000
0000000000000000000000004554554400000000445494540000000011111111d0dd101155d6d6666d6dd66dd5101dddd0dd1044440044000044004444401ddd
0000000000000000000000004454455400000000449944540000000011111111d01d10155556d6d6666ddd6d151011d1d01d10444204444004444042444011d1
0000000000000000000000004454454500000000559a9555000000001111111110111011ddd6dd6d6d666dddd5101d1110111042204444444444442044401d11
000000000000000000000000545545440000000045464544000000001111111110111015d66d66666776dd5dd510111110111040044444444444440444401111
000000000000000000000000455455440000000045464544000000001111111110101015dd66676777776dd5d510011110101044444444444444444444400111
00000000000000000000000044544554000000005555555500000000111111111011001dd66d77767777666ddd10001110110044444444424444424444400011
00000000000000000000000044544545000000004454445400000000111111111010005dd6d67777777677d65d10000010100022222222202222202222200000
00000000000000000000000054554544000000004454445400000000111111110000000000000000000000000010000000000000000000000000000000000000
77777777177777771777777717777777177777771777777717777777177777771777777717777777177777771777777777707777777777777777777777777077
76677777176777671767776717777767177777671776676710777667177776671777776717766767177776671777766776607767677666666666666767667067
76767777177776671766777717767667177776671766777709077767176777671777766717667777177777671767776776707676766666666666666676777067
77777777177777771777777717777777177777771777777099077777177777771777777717777707177777771777777777607777777777777777777777777077
66666666166666661666666616666666166666661666670990776666166666661666666616667090166666661666666666606666666666666666666666666066
666666d6166666661666666d166666d6166666d616667009a90766661666d6d6166666d6166709a9176766661666d6d6666100000000000000000000000001d6
666ddd6d16666d6d1666d6dd16666d6d166ddd6616670909aa90767616666d6d166ddd6616709a901766766616666d6d666d1022022220222220222202201d6d
dddd1ddd1ddddddd1dddddd11ddddddd1dddd667177770009a907777176666dd1dddd6671777090017776777176666dddddd1022024220242420222202201ddd
1111011111111111111111111111111111111111111110900a011111111111111111111111111009011111111111111111100022044440244240422402200011
6666166666666616666616666666661666661667677709009a9077776766661d666616676777609a907767776666661d66661022022440244440444402201616
d6dd1666d6d6dd16d6dd1666d6d6d616d6dd1dd676670a90aaa907766666d61dd6dd1dd67666609aa90666666666d61dd6dd1022020440444200244404201616
6ddd166d6d6ddd1d6ddd166d6ddddd1d6ddd1ddd66709aa9aaa907666ddddd1d6ddd1dddddd66609aa9076d66ddddd1d6ddd1022022040244420444402201d1d
dddd1ddddddddd1ddddd1ddddddddd1ddddd16dd666709aa7a900766ddd6dd1ddddd1ddddddd609aa79076ddddd6dd1ddddd1024024240424440444404201d1d
dddd1ddddddddd1ddddd1ddddddddd1ddddd1dddd66770a77a9076766ddddd1ddddd16ddddd760aa7a9076dd6ddddd1ddddd1022022440444440402402201d1d
d1dd11d1ddd1d10dd1dd01d1ddd1d10dd1dd11d666667097aa07766666ddd11dd1dd11dd6d6670977a00766666ddd11dd1d1102404244040244002440420110d
11110111111110011110001111111001111111111111110970111111111111111111111111111109700901111111111111100022042440024420242204200000
6666661666666666666606666666666666666616767777049077777676661666666666167677770490707776dddd166666661022044440244440404202201666
d6dddd16d6dd6ddddddd16d6d6ddddddd6dddd16d6667074470766d6d6dd1dddd6dddd1dd6667074470766dddddd1dddd6dd1024024440442440070202201ddd
dddddd1d6ddddddddddd1d6ddddddddddddddd1dd6d670677607666ddddd1ddddddddd1dddd6706776076ddddddd1ddddddd102402024044224076d002201ddd
dddddd1ddddddddddddd1ddddddddddddddddd1ddd66605665076ddddddd1ddddddddd1ddddd605665076ddddddd1ddddddd10220024404222400d0202201ddd
dddddd0dddddddddddd10dddddddddd1dddddd0dddd6600550066d6ddddd1dd1dddddd01dddd6005500d6dddddd11dd1dddd10220244404224402024042011d1
dddd1d01d1dddd1dd1110ddd1ddddd11dddd1d0ddddd6d0000d66ddd1ddd1d11dd1d110111dddd0000d66ddd1d110d11ddd11022022420442440424204201d11
11111100101111111110001111111110111111011d166104401166d1111111101111110001166104401166d10110011011111022024420244440244202201110
00000000000000000000000000000000000000000000000420000000000000000000000000000002400000000000000000000022044440244400244402200000
d0dddddddddd0ddddddddddddd0dddddd0ddddddd6660d0220d666dddd0dddddd0ddddddd6dd0d0220d666dddd0dddddd0dd1024044200244020442404201ddd
d0dd1d1d1dd10ddddddd1dddd10dd1d1d0dd1d1dddd60d1001d6ddddd10dd1d1d0dd1d11dd110d1001d611ddd10dd1d1d01d10240444202440204424042011d1
10d1d1d1111d0d1d1d11111d110d1d1110d1d1d1d1d106d11d6dd1d1110d1d1110d1d1d1111101d11d6d1111110d1d1110111024024440440240444402201d11
101d1111111101d111d111d11101d111101d111111110d1101dddd111101d111101d11111111010111d111111101d11110111022024420242440244402201111
1011111111110111d1111111110111111011111111110110111d1111110111111011111111110110111111111101111110101022022420444440242202200111
10111111011100111111111101011111101111101111010001111111110111111011111011110100011111111101111110110022022220222220222202200011
10011110001000011111001110001110100111100110000000010011100011101001111001100000000100111000111010100000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000044440000444440044444444444444404444444444004444400004444004444477777777111102247777777744444444
05000455554440000445554455400000244440000444444044444444444444204444444444044444400004444200444476677767777702447677766744444444
040660455444554041454d4454066000444244044442444444444424444444404444444444444444444044244404444476767777766702247777676744444424
016dd5055554555014444554506dd500444024044220244444444402244444444440244444444444002044044444444476777777767702047777776744444402
006dd5055445d4505544d554506dd50044444404200444444444444002444444400244444444444422404444444444447767d66677770224666d767744444440
040550455455d450dd6d54445405504044444204444444444444444444444422422444444444444444402444442244447777ddd6776702426ddd777744444444
054004455446000000055544554004d022222000222222222222222222222200222222222222222222000222220022227767dd6d77770222d6dd767722222222
054545455540766646d05454545d6d50000000000000000000000000000000000000000000000000000000000000000076671ddd77770000ddd1766700000000
054555dd6dd060d4d050445dd6d44440444444444444444444000444444444444444400044444444444444444444444477771111422011111111777700000000
054554d4445065444550515544555550000444444244444444400444442244444444400444444444444444400044444411111666442077776661111100000000
05454655444400000005601445554450202444422024444444404444440024444444440444444444044444420244440077771666422076676661777700000000
0444464444444540555dd5555544444042444420044444444440444444440444444444044444444420044444244440227767166d40207767d661767700000000
05445544454455505555555555554410444444444444444444202444444444444444420244444444422444444444424477671ddd42207777ddd1767700000000
04546445544554504455455455554540444444444444444442000244444444444444200024444444444444444444444476671ddd44207677ddd1766700000000
016d4445144445401544444444545410222222222222222220000022222222222222000002222222222222222222222277771ddd22207777ddd1777700000000
00141444014111100144444114111400000000000000000000000000000000000000000000000000000000000000000077771111000077771111777700000000
00010111001000000011111000000100444444444444444444444400044440444000444444444444444444444444044477771ddd00000000ddd1777700000000
00054444454400000400055555455000422440244444444444444440444444244404444444444444444204422444444411111ddd00000000ddd1111100000000
0045555455d4445004044455555444002002424444444444444444402444440442044444444444444444242002404444777711dd00000000dd11777700000000
0045555555d54440444555544554440044404444444444444422444004200024400444224444444444444404444200027667011d00000000d110766700000000
04555d6d6d55545045445d4d455154404444444444444444420024404442224444044200244444444444444444442224776701d1000000001d10767700000000
0544d55114455550544640000000000002444444444442222044442024444444420244440222244444444444204444447777011d00000000d110777700000000
055d555401455510544d0666666644d0002222222222200000222200022222222000222200000222222222220022222277770111000000001110777700000000
0554454500554d4044dd060dd4ddd040000000000000000000000000000000000000000000000000000000000000000076770000000000000000776700000000
0554554544544d40d4d506dd44dddd5004444444400044444444444444004400444444444444440004444444400044007767011100000000dd10767700000000
0540045544445640545506d444dd4d4044200244440024424444442442044440444244444424420044444002440444207777011100000000dd10777700000000
0406604555556d50545404dd4ddddd4044444024440402204444440220444444022044444402204044420224444444421111011100000000d110111100000000
016dd50555d655505454044dddddd440444444444404400444444440044444442004444444400440444424444444444477770111000000001110777700000000
006dd5055d444440555404ddddd4dd40444444444404444444444444444444444444444444444440444444444444444476670001000000001000766700000000
05055045444554101154060dd444d050244444444402444444444444444444424444444444444420444444444224444477670010000000000100767700000000
015004555445150005550d5554555550022222222200222222222222222222202222222222222200222222222002222277770000000000000000777700000000
00155111111101000111100000000000000000000000000000000000000000000000000000000000000000000000000077770000000000000000777700000000
__gff__
00000000000000000000000000010101000000000000000000000000000100010000000a0000000000000000000101010000000000000000000000000000000000000000000000000404040104040401000100010101000014040404140000040000000000000000040404010400000100000000000000000404040104000001
0101010101010101010101010505050501010101010101010101010105050505010101010101010101010101050505050101010101010101010101010505050500000000000000000000000001010108000000000000000000000000010101000000000000000000000000000100010000000000000000000000000001000100
__map__
cc818283808182838485868780818248494a4b8388898a8b80ce000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dc919293909192939495969790919258595a5b9398999a9b90de000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eca1a2a3a0a1a2a3a4a5a6a7a0a1a268696a6ba3a8a9aaaba0ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fcb1b2b3b0b1b2b3b4b5b6b7b0b1b278797a7bb3b8b9babbb0fe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdc4c5c6c7c8c9cacbc4c5c6c7c4c5c6c7c4c5c6c7c8c9cacbdd8388898a8bce000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdd4d5d6d7d8d9dadbd4d5d6d7d4d5d6d7d4d5d6d7d8d9dadbdd9398999a9bde000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdc8c9cacbe8e9eaebc4c5c6c7c8c9cacbc4c5c6c7e8e9eaebdda3a8a9aaabee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdd8d9dadbf8f9fafbd4d5d6d7d8d9dadbd4d5d6d7f8f9fafbddb3b8b9babbfe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cde8e9eaebe4e5e6e7e4e5e6e7e8e9eaebe4e5e6e7e4e523e7ddc4c5c6c7d7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdf8f9fafbf4f5f6f7f4f5f6f7f8f9fafbf4f5f6f7f4f5f6f7ddd4d523d7e7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc81828380818283808182838c8d8e8f80818283808182838081e4e5e6e7f7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dc91929390919293909192939c9d9e9f90919293909192939091f4f5f6f7d7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eca1a2a3a0a1a2a3a0a1a2a3acadaeafa0a1a2a3a0a1a2a3a0a1f8e4e5e6e7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fcb1b2b3b0b1b2b3b0b1b2b3bcbdbebfb0b1b2b3b0b1b2b3b0b1e4f4f5f6f7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdc5c6c7c4c5c6c7c4c5c6c7c4c5c6c7c4c5c6c7c4c5c6c7c4c5c6d4d5d6d7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdd5d6d7d4d5d6d7d4d5d6d7d4d5d6d7d4d5d6d7d4d5d6d7d4d5d6e4e5e6e7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cde5e6e7e4e5e6e7e4e5e6e7e4e5e6e7e4e5e6e7e4e5e6ddcde5e6f4f5f6f7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdc5c6c7c4c5c6c7c4c5c6c7c4c5c6c7c4c5c6c7c4c5c6ddcdc5c6d4d5d6d7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cdd5d6d7d4d5d6d7d4d5d6d7d4d5d6d7d4d5d6d7d4d5d6ddcdd5d6e4e5e6e7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cde5e6e7e4e5e6e7e4e5e6e7e4e5e6e7e4e5e6e7e4e5e6ddcde5e6f4f5f6f7dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8081828380818283808182838182838081828380818283818081828380818283000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9091929390919293909192939192939091929390919293919091929390919293000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0a1a2a3a0a1a2a3a0a1a2a3a1a2a3a0a1a2a3a0a1a2a3a1a0a1a2a3a0a1a2a3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e4b1b2b3b0b1b2b3b0b1b2b3b1b2b3b0b1b2b3b0b1b2b3b1b0b1b2b3b0b1b2b3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000028670206600406004050040400404004040040400403004030040300302003020030100301002010000100200003000030000400004000141001410014100141001410000000000000000000000
__music__
00 00024344

