.data
############################################  DATA METHODE SUPPRESION  ################################################

nemsg: .asciiz "DESOLÉ ! Le contact que vous voulez supprimé n'existe pas dans votre carnet d'addresse!"
eqmsg: .asciiz "Le contact que vous voulez supprimé est bien dans votre carnet d'addresse!"
point: .asciiz "."

###########################     buffer suppression    ###########

Buffer_principal: .space 600  #doit être utiliser comme FinalString pour l'écriture 
Buffer_secondaire : .space 600

######################################         FIN DATA SUPRESSION     #################################################

######################################        DATA AJOUT      #######################################################

#############   fichier  #############

fileName: .asciiz "C:/CarnetAdresse.txt" #le fichier que j'ouvre
fileWords: .space 1024 #buffer

############  Different message a afficher ajout ################

carnet : .asciiz "votre carnet d'adresse contient : \n"
home : .asciiz "\nBonjour, que voulez vous faire ?\n Ajouter un contact (1) ?\n en modifier un (2)?\n ou en supprimer (3) ?"
presentationSupp : .asciiz "vous allez supprimer un contact, qui voulez vous supprimer ? \n"   #rentrer le nom erreur si numero
presentationModif : .asciiz "vous allez modifier un contact, vous allez dans un premier temps supprimer un contact puis ajouter un contact \n"     #rentrer le nom erreur si numero
presentationAjout: .asciiz "vous allez créer un nouveau contact.  \n "                #rentrer le nom erreur si numero

##########################    MSG DE DEMANDE       ################################

nom: .asciiz "veuillez saisir le nom du contact en mettant un point , comme premier caractère(ex .Pierre) :\n "
prenom: .asciiz "veuillez saisir le prénom du contact :\n "
tel: .asciiz "veuillez saisir le numero de telephone :\n "
codeP: .asciiz "veuillez saisir le code postale :\n "
msgFin: .asciiz "/n travail terminer. \n"

########  MSG DE CONFIRMATION ############

ajoutDe : .asciiz "ajout de : "
modifDe : .asciiz "modification de : "
suppDe : .asciiz "suppression de : "

##################### BUFFER QUI CONTIEN LES DONNES A AJOUTER ####################

name: .space 1024 # buffer du name rajouter par l'utilisateur
prename: .space 1024 # buffer du prename rajouter par l'utilisateur
telS : .space 1024 # buffer du tel rajouter par l'utilisateur
codePS: .space 1024 # buffer du codePostal rajouter par l'utilisateur
finalString: .space 1024 # buffer qui a le string final concatainer


####################################             #############################################################
###################################       DATA               #############################################################
########################################       #############################################################    

.text 


li $v0,4
la $a0,carnet
syscall 

    #lecture de l'adrrese du fichier

    li $v0,13               # ouvre le fichier avec code = 13
        la $a0,fileName         # prend le nom du fichier
        li $a1,0            #code droit de lecture = 0
        syscall
        
        move $s0,$v0            # on met le nom du fichier dans une valeur de sauvegarde
    

    #lecture dans le fichier 

    li $v0, 14      # lecture du fichier avec code = 14
    move $a0,$s0        # file descriptor
    la $a1,fileWords    # on stock le contenu entier du fichier dans $a1
    la $a2,1024     # on fixe une taille pour $a2
    syscall


    #affichage dans la console de filewords qui contient toute les données du fichier 

    li $v0, 4       # lecture de fileWords code = 4
    la $a0,fileWords        #print de fileWords dans la console
    syscall

    

    #fermeture du fichier

        li $v0, 16              # fermeture du fichier avec le code = 16
        move $a0,$s0            #on enleve ladresse du fichier sauvegarde dans $s0 pour la mettre dans $a0
        syscall







li $v0,4    #print avec code = 4
la $a0,home #phrase du home
syscall 


#########      FIN DE L AFFICHAGE DE DEBUT QUI MONTRE LE CARNET + DEMANDE ACTION        #################################

li $v0, 5   #code pour stock valeur interraction
syscall
move $t1, $v0  #on charge la valeur rentrer par l'user dans $t1

li $t2,1 # 1 est la valeur décidée pour la methode ajout
li $t3,2 # 2 est la valeur décidée pour la methode modif
li $t4,3 # 3 est la valeur décidée pour la methode supp

beq $t1,$t2,ajout   # comparaison valeur user egale a 1 lancement ajout
beq $t1,$t3,modif #comparaison valeur user egale a 2 lancement modif
beq $t1,$t4,supp #comparaison valeur user egale a 3 lancement supp

#######################################           1ER TRIO DEBUT                  #############################################

ajout :

li $v0,4 #code affichage print 
la $a0,presentationAjout #affiche presentation de lajout
syscall

j methodeAjout #lancement methode ajout



modif :

li $v0,4 #code affichage print
la $a0,presentationModif  #affiche presentation de la modif 
syscall

addi $t3,$t3,1  
j supp  #lancement methode supp

############################################################################################################################################################################################
######################### methode ajout dans modif debut ###################################################################################################################################
############################################################################################################################################################################################
modif2:

li $v0,4    #code affichage 
la $a0,nom   #demande nom
syscall

li $v0,8 #code stock nom
la $a0,name #stock nom
li $a1,20
syscall 



li $v0,4 #code affichage ,4 
la $a0,prenom  #demande prenom
syscall



li $v0,8  #code stock nom
la $a0,prename #stock prenom
li $a1,20   
syscall 

li $v0,4
la $a0,tel  #demande tel
syscall

li $v0,8
la $a0,telS #stock tel
li $a1,20
syscall 

li $v0,4
la $a0,codeP  #demande codeP
syscall

li $v0,8
la $a0,codePS #stock tel
li $a1,20
syscall 

#message d'ajout d'un contact

li $v0, 4
la $a0,ajoutDe
syscall

li $v0,4    #code 4 print name
la $a0,name 
syscall 

li $v0,4
la $a0,prename   #code 4 print prename
syscall 

li $v0,4
la $a0,telS #code 4 print tel
syscall 

li $v0,4
la $a0,codePS   #code 4 print codePostal
syscall 

########################          ON RENTRE LES VALEURS DANS LE FICHIER TEXTE      ##############################

#ouverture fichier  

        li $v0,13               # ouverture code = 13
        la $a0,fileName         # avoir ladresse contenu dans "filename"
        li $a1,1            # code droit ecriture = 1
        syscall
        move $s1,$v0            #sauvegarrde avec le deplacement

        #Write the file
        li $v0,15       # ecriture dans  = 15
        move $a0,$s1        

    

 ############### ça c'est pour concatainer le fileword et le name dans finalString ################     

        # Sauvegarde les différents Strings
        la $s2, finalString  
        la $s3, Buffer_principal 
        la $s4, name
        la $s5, prename
        la $s6, telS
        la $s7, codePS

        Mcopy1String:   

        lb $t0, ($s3)                 #copie du caractere 
        beqz $t0, Mcopy2String    ######si egale a 0 donc changement de label et de mot !!!
        sb $t0, ($s2)            ###### sinon on stock dans $s2 !!

        addi $s3, $s3, 1               # parcourt le mot de 1 en 1 
        addi $s2, $s2, 1               # par court le final string de 1 en 1 
        j Mcopy1String              # boucle     


        Mcopy2String:  

        lb $t0, ($s4)                  
    beqz $t0, Mcopy3String              
        sb $t0, ($s2)                  # meme methode que copy1String

        addi $s4, $s4, 1             
        addi $s2, $s2, 1                
        j Mcopy2String             # boucle   

    

    Mcopy3String:

    lb $t0, ($s5)                   
    beqz $t0, Mcopy4String              
    sb $t0, ($s2) 
                     
    addi $s5, $s5, 1                 # meme methode que copy1String
    addi $s2, $s2, 1               
    j Mcopy3String    

    

    Mcopy4String:

     lb $t0, ($s6)                 
    beqz $t0, Mcopy5String             # meme methode que copy1String
    sb $t0, ($s2)                   

    addi $s6, $s6, 1              
    addi $s2, $s2, 1            
    j Mcopy4String

        

    Mcopy5String:

     lb $t0, ($s7)                 
    beqz $t0, Msuite             
    sb $t0, ($s2)                   # meme methode que copy1String

    addi $s7, $s7, 1            
    addi $s2, $s2, 1              

    j Mcopy5String #saut au tag Mcopy5String

###################                j'ai fini la concataination Pour la modification     ####################################################################

        Msuite: # label pour sortir de la concatenation

        la  $a1,finalString # string qui va etre ecrit dans le fichier  
        la $a2,600      # taille de la chaine concatainer
        syscall

    #le fichier doit etre ferme pour son actualisation 

        li $v0,16               # code pour close
        move $a0,$s1            
        syscall

j fin #saut au label fin




######################## methode ajout dans modif debut #########################################

supp:

li $v0,4  #code affichage print
la $a0,presentationSupp   #affiche presentation de la suppresion 
syscall

j methodeSupp #lancement methode supp

#######################################               1ER TRIO FIN             #############################################

#######################################               2ER TRIO DEBUT           #############################################

##### l' utilisateur va entrer les infos pour les mettre dans le carnet 

methodeAjout:

li $v0,4    #code affichage 
la $a0,nom   #demande nom
syscall

li $v0,8 #code stock nom
la $a0,name #stock nom
li $a1,20
syscall 



li $v0,4 #code affichage ,4 
la $a0,prenom  #demande prenom
syscall



li $v0,8  #code stock nom
la $a0,prename #stock prenom
li $a1,20
syscall 



li $v0,4
la $a0,tel  #demande tel
syscall



li $v0,8
la $a0,telS #stock tel
li $a1,20
syscall 



li $v0,4
la $a0,codeP  #demande codeP
syscall



li $v0,8
la $a0,codePS #stock tel
li $a1,20
syscall 



#message d'ajout d'un contact

li $v0, 4
la $a0,ajoutDe
syscall



li $v0,4    #code 4 print name
la $a0,name 
syscall 

li $v0,4
la $a0,prename   #code 4 print prename
syscall 

li $v0,4
la $a0,telS #code 4 print tel
syscall 

li $v0,4
la $a0,codePS   #code 4 print codePostal
syscall 

########################          ON RENTRE LES VALEURS DANS LE FICHIER TEXTE      ##############################

#ouverture fichier  

        li $v0,13               # ouverture code = 13
        la $a0,fileName         # avoir ladresse contenu dans "filename"
        li $a1,1            # file flag = write (1)
        syscall
        move $s1,$v0            #sauvegarrde avec le deplacement

        #Write the file
        li $v0,15       # ecriture dans  = 15
        move $a0,$s1        

    

 ############### ça c'est pour concatainer le fileword et le name dans finalString ################     

        # Sauvegarde les différents Strings

        la $s2, finalString  
        la $s3, fileWords 
        la $s4, name
        la $s5, prename
        la $s6, telS
        la $s7, codePS

        copy1String:    

        lb $t0, ($s3)                 #copie du caractere 
        beqz $t0, copy2String    ######si egale a 0 donc changement de label et de mot !!!
        sb $t0, ($s2)            ###### sinon on stock dans $s2 !!

        addi $s3, $s3, 1               # parcourt le mot de 1 en 1 
        addi $s2, $s2, 1               # par court le final string de 1 en 1 
        j copy1String              # boucle     


        copy2String:  

        lb $t0, ($s4)                  
    beqz $t0, copy3String              
        sb $t0, ($s2)                  # meme methode que copy1String

        addi $s4, $s4, 1             
        addi $s2, $s2, 1                
        j copy2String             # boucle   

    

    copy3String:

    lb $t0, ($s5)                   
    beqz $t0, copy4String              
    sb $t0, ($s2) 
                     
    addi $s5, $s5, 1                 # meme methode que copy1String
    addi $s2, $s2, 1               
    j copy3String    

    

    copy4String:

     lb $t0, ($s6)                 
    beqz $t0, copy5String             # meme methode que copy1String
    sb $t0, ($s2)                   

    addi $s6, $s6, 1              
    addi $s2, $s2, 1            
    j copy4String #permet la boucle

        

    copy5String:

     lb $t0, ($s7)                 
    beqz $t0, suite             
    sb $t0, ($s2)                   # meme methode que copy1String

    addi $s7, $s7, 1            
    addi $s2, $s2, 1              

    j copy5String


###################                j'ai fini la concataination     ####################################################################

        suite: # label pour sortir de la concatenation

        la  $a1,finalString # string qui va etre ecrit dans le fichier  
        la $a2,1000     # taille de la chaine concatainer
        syscall

    #le fichier doit etre ferme pour son actualisation 

        li $v0,16               # code pour close
        move $a0,$s1            
        syscall

j fin 


#############################    chercher le mot    ##############


methodeSupp:

#avoir string user

li $v0,8
la $a0,name
li $a1,20
syscall 

#message supp

li $v0, 4
la $a0,suppDe
syscall

#on place le nom a la fin du msg

li $v0,4
la $a0,name 
syscall 


######################################     methode de supression dans le carnet   ########################################

    #prend les contact present dans le fichier  
    la  $s0,fileWords
    move $t0,$s0


    #prend le nom recherché renseigné par l'user 
    la  $s1,name
    move $t1,$s1
   
    la  $s2,name
    move $t2,$s2 

#####################    rajout des buffer     ################

        la $s3, Buffer_principal #buffer de la boucle principal    
        la $s4, Buffer_secondaire #buffer de la boucle secondaire  
         

#####################    rajout des buffer     ################



principalloop: 
#permet de charger les contact de filewords dans le buffer principal avant de trouver le mot recherché avec son point


    lb  $t0,($s0)     # prend le caractere de $s0 ( fichier contact)
    lb  $t1,($s1)     # prend le caractere de $s1 (mot recherché)

    beq  $t0,$t1 ,testprecis  #si 1er lettre du mot recherhcé est trouvé dans le fichier contact -> lancement testprecis
    beqz  $t0, negatif  #si 1er lettre du mot recherhcé   N'   est   PAS   trouvé  dans le fichier contact -> lancement testprecis

    sb $t0, ($s3)     #buffer principal, met le caractère de t0 dans s3 (buffer principal) 

    addi $s0,$s0,1     #parcourt caractere 1 à 1 avance dans le buffer (filewords)
    addi $s3,$s3,1     #avance dans le buffer (buffer_principal)

    j  principalloop 

    #comparateur de string (secondaire)
    
testprecis:

add $s2,$zero,$s1   ###### réinitialise le mot rechercher ######

testprecis2:

    lb  $t0,($s0)  #Liste principal   
    lb  $t2,($s2) #mot rechercher
    sb $t0, ($s4) # buffer secondaire, met le caractère de t0 dans s4 (buffer secondaire) 
    lb  $t4,($s4)

    addi $s0,$s0,1     #avance avec avec un pas de 1
    addi $s2,$s2,1      #avance avec avec un pas de 1
    addi $s4,$s4,1     #avance avec avec un pas de 1 dans le buffer  (buffer_secondaire)
    addi $t9,$t9,1        #compteur de boucle secondaire

    beq $t2, 10 , positif  #le mot chercher EST DANS LE CARNET !!
    bne  $t0,$t2, concat    # si c'est différent, concat les caractères du buffer principal et secondaire.

     j  testprecis2 


  ################################ concat #######################################

  concat: 

        sub $s4,$s4,$t9  #permet de lire correctemet le buffer_secondaire
        sub $t9, $t9,$t9  # réinitialise le compteur de boucle secondaire

        concat2:    

        lb $t4, ($s4)                  # on prend le caractères du buffer_secondaire
        beqz $t4, principalloop              # reourne dans la boucle Principale
        sb $t4, ($s3)                  # Stocke dans le buffer principal
        addi $s3, $s3, 1               # avance de 1 dans $s3  
        addi $s4, $s4, 1 

        j concat2                       # boucle    


   ################################ concat #######################################


# Le nom n'est pas dans le carnet 

negatif: 

    la  $a0,nemsg 
    li  $v0,4 
    syscall 

    la  $a0,Buffer_principal
    li  $v0,4
    syscall

 j fin

# si on trouve le mot rechecher

positif: 

#vérifie si le mot trouver est bien entier

beq $t0, 10,positifloop     
beq $t0,13,positifloop
beq $t0, 32,positifloop

j concat

positifloop:  
# permet de ne pas prendre dans le buffer_principal tous les éléments entre le nom et un point "." .

    la $s7,point
    lb  $t0,($s0)                        #charge le caractere de $s0 ( 1 à 1)
    lb  $t1,($s7)                         # valeur d'arret qui est le point dans notre carnet
    beq $t0, $t1 , finpositif            # si $t0 = point saut dans le label finpositif
    addi $s0,$s0,1                       # avance avec un pas de 1 caractere

    j  positifloop       #boucle

finpositif:
#permet de suprimer le dernier point de la liste

addi $s0,$s0,1
lb  $t0,($s0)  
beqz  $t0, finfinpositif
sub $s0,$s0,1 

finpositifloop:
#permet de charger les valeurs de filewords dans le buffer principal apres ignorer le contact supprimé


    lb  $t0,($s0)     #charge le caractere de filwords 
    beqz  $t0, finfinpositif  # la liste principal est entirement dans le buffer
    sb $t0, ($s3)     #buffer principal, met le caractère de t0 dans s3 (buffer principal 
    addi $s0,$s0,1     #avance avec un pas de 1
    addi $s3,$s3,1     #avance dans le buffer
    j  finpositifloop 

finfinpositif:

    la  $a0,eqmsg 
    li  $v0,4 
    syscall

    li  $v0,4
    la  $a0,Buffer_principal 
    syscall

###### écris dans le fichier pour supprimer le conctact  

#ouverture fichier  

        li $v0,13               # ouverture code = 13
        la $a0,fileName         # avoir ladresse contenu dans "filename"
        li $a1,1            # file flag = write (1)
        syscall

        move $s1,$v0            #sauvegarrde avec le deplacement
        
        #ecrire dans le fichier

        li $v0,15       # ecriture dans  = 15
        move $a0,$s1    
        
        la  $a1,Buffer_principal    # string qui va etre ecrit dans le fichier
        la $a2,600      # taille de la chaine concatainer
        syscall

        

    #le fichier doit etre ferme pour son actualisation 

        li $v0,16               # code pour close
        move $a0,$s1            
        syscall
        
        beq $t3,3, modif2

j fin 

fin : 

li $v0,4
la $a0,msgFin #message de confirmation de fin du programme
syscall 
