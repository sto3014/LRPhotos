FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        l     ��������  ��  ��     	 
 	 l     ��  ��    3 - Extract the album name from the session file     �   Z   E x t r a c t   t h e   a l b u m   n a m e   f r o m   t h e   s e s s i o n   f i l e 
     i         I      �� ���� $0 extractalbumname extractAlbumName   ��  o      ���� "0 sessioncontents sessionContents��  ��    k     i       r         m        �      o      ���� 0 	albumname 	albumName      r    	    n         2    ��
�� 
cpar   o    ���� "0 sessioncontents sessionContents  o      ���� 0 alllines allLines   ! " ! X   
 f #�� $ # k    a % %  & ' & r    % ( ) ( l   # *���� * I   #���� +
�� .sysooffslong    ��� null��   + �� , -
�� 
psof , m     . . � / /  = - �� 0��
�� 
psin 0 o    ���� 0 aline aLine��  ��  ��   ) o      ���� "0 equalsignoffset equalSignOffset '  1�� 1 Z   & a 2 3���� 2 ?   & ) 4 5 4 o   & '���� "0 equalsignoffset equalSignOffset 5 m   ' (����   3 k   , ] 6 6  7 8 7 r   , ; 9 : 9 n   , 9 ; < ; 7  - 9�� = >
�� 
ctxt = m   1 3����  > l  4 8 ?���� ? \   4 8 @ A @ o   5 6���� "0 equalsignoffset equalSignOffset A m   6 7���� ��  ��   < o   , -���� 0 aline aLine : o      ���� 0 var   8  B�� B Z   < ] C D���� C =   < ? E F E o   < =���� 0 var   F m   = > G G � H H  a l b u m _ n a m e D r   B Y I J I n   B W K L K 7  C W�� M N
�� 
ctxt M l  G S O���� O [   G S P Q P l  H Q R���� R I  H Q���� S
�� .sysooffslong    ��� null��   S �� T U
�� 
psof T m   J K V V � W W  = U �� X��
�� 
psin X o   L M���� 0 aline aLine��  ��  ��   Q m   Q R���� ��  ��   N m   T V������ L o   B C���� 0 aline aLine J o      ���� 0 	albumname 	albumName��  ��  ��  ��  ��  ��  �� 0 aline aLine $ o    ���� 0 alllines allLines "  Y�� Y L   g i Z Z o   g h���� 0 	albumname 	albumName��     [ \ [ l     ��������  ��  ��   \  ] ^ ] l     �� _ `��   _ 4 . Extract checkDuplicates from the session file    ` � a a \   E x t r a c t   c h e c k D u p l i c a t e s   f r o m   t h e   s e s s i o n   f i l e ^  b c b i     d e d I      �� f���� 00 extractcheckduplicates extractCheckDuplicates f  g�� g o      ���� "0 sessioncontents sessionContents��  ��   e k     o h h  i j i r      k l k m     ��
�� boovfals l o      ���� "0 checkduplicates checkDuplicates j  m n m r    	 o p o n     q r q 2    ��
�� 
cpar r o    ���� "0 sessioncontents sessionContents p o      ���� 0 alllines allLines n  s t s X   
 d u�� v u Q    _ w x y w Z    J z {���� z >   " | } | n      ~  ~ 1     ��
�� 
pcnt  o    ���� 0 aline aLine } m     ! � � � � �   { k   % F � �  � � � r   % * � � � m   % & � � � � �  = � n      � � � 1   ' )��
�� 
txdl � 1   & '��
�� 
ascr �  ��� � Z   + F � ����� � =  + 1 � � � n   + / � � � 4   , /�� �
�� 
citm � m   - .����  � o   + ,���� 0 aline aLine � m   / 0 � � � � �   c h e c k _ d u p l i c a t e s � k   4 B � �  � � � r   4 : � � � n   4 8 � � � 4   5 8�� �
�� 
citm � m   6 7����  � o   4 5���� 0 aline aLine � o      ���� ,0 checkuplicatesastext checkuplicatesAsText �  � � � r   ; @ � � � c   ; > � � � o   ; <���� ,0 checkuplicatesastext checkuplicatesAsText � m   < =��
�� 
bool � o      ���� "0 checkduplicates checkDuplicates �  ��� �  S   A B��  ��  ��  ��  ��  ��   x R      �� ���
�� .ascrerr ****      � **** � o      ���� 0 e  ��   y k   R _ � �  � � � I  R [�� ���
�� .ascrcmnt****      � **** � b   R W � � � b   R U � � � m   R S � � � � � f e r r o r   i n   e x t r a c t C h e c k D u p l i c a t e s ( )   w h i l e   c o n v e r t i n g   � o   S T���� ,0 checkuplicatesastext checkuplicatesAsText � m   U V � � � � �    t o   b o o l e a n .��   �  ��� � r   \ _ � � � m   \ ]��
�� boovfals � o      ���� "0 checkduplicates checkDuplicates��  �� 0 aline aLine v o    ���� 0 alllines allLines t  � � � r   e l � � � m   e h � � � � �    � n      � � � 1   i k��
�� 
txdl � 1   h i��
�� 
ascr �  ��� � L   m o � � o   m n���� "0 checkduplicates checkDuplicates��   c  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � = 7 Import exported photos in a new iPhoto album if needed    � � � � n   I m p o r t   e x p o r t e d   p h o t o s   i n   a   n e w   i P h o t o   a l b u m   i f   n e e d e d �  � � � i     � � � I      �� ����� 
0 import   �  � � � o      ���� 0 sourcefolder sourceFolder �  � � � o      ���� 0 	albumname 	albumName �  ��� � o      ���� "0 checkduplicates checkDuplicates��  ��   � k     � � �  � � � r      � � � c      � � � 4     �� �
�� 
psxf � o    ���� 0 sourcefolder sourceFolder � m    ��
�� 
alis � o      ���� 0 thepath thePath �  � � � r   	  � � � o   	 
���� 0 thepath thePath � o      ���� 0 	thefolder 	theFolder �  � � � r     � � � I    �� ����� 0 getimagelist getImageList �  ��� � o    �� 0 	thefolder 	theFolder��  ��   � o      �~�~ 0 	imagelist 	imageList �  ��} � O    � � � � k    � � �  � � � Z    � � ��| � � =   ! � � � o    �{�{ 0 	albumname 	albumName � m      � � � � �   � Z   $ = � ��z � � =  $ ' � � � o   $ %�y�y "0 checkduplicates checkDuplicates � m   % &�x
�x boovtrue � r   * 1 � � � I  * /�w ��v
�w .IPXSimponull���     **** � o   * +�u�u 0 sourcefolder sourceFolder�v   � o      �t�t 0 	medialist 	mediaList�z   � r   4 = � � � I  4 ;�s � �
�s .IPXSimponull���     **** � o   4 5�r�r 0 sourcefolder sourceFolder � �q ��p
�q 
skDU � m   6 7�o
�o boovtrue�p   � o      �n�n 0 	medialist 	mediaList�|   � k   @ � � �  � � � Z   @ [ � ��m�l � H   @ I   l  @ H�k�j I  @ H�i�h
�i .coredoexnull���     **** 4   @ D�g
�g 
IPal o   B C�f�f 0 	albumname 	albumName�h  �k  �j   � r   L W I  L U�e�d
�e .corecrel****      � null�d   �c
�c 
kocl m   N O�b
�b 
IPal �a	�`
�a 
naME	 o   P Q�_�_ 0 	albumname 	albumName�`   o      �^�^ 0 lralbum lrAlbum�m  �l   � 
�]
 Z   \ ��\ =  \ _ o   \ ]�[�[ "0 checkduplicates checkDuplicates m   ] ^�Z
�Z boovtrue r   b p I  b n�Y
�Y .IPXSimponull���     **** o   b c�X�X 0 	imagelist 	imageList �W�V
�W 
toAl 4   d j�U
�U 
IPct o   h i�T�T 0 	albumname 	albumName�V   o      �S�S 0 	medialist 	mediaList�\   X   s ��R k   � �  r   � � J   � � �Q o   � ��P�P 	0 image  �Q   o      �O�O 0 	shortlist 	shortList �N r   � � !  I  � ��M"#
�M .IPXSimponull���     ****" o   � ��L�L 0 	shortlist 	shortList# �K$%
�K 
toAl$ 4   � ��J&
�J 
IPct& o   � ��I�I 0 	albumname 	albumName% �H'�G
�H 
skDU' m   � ��F
�F boovtrue�G  ! o      �E�E 0 	medialist 	mediaList�N  �R 	0 image   o   v w�D�D 0 	imagelist 	imageList�]   � ()( l  � ��C*+�C  * "  repeat while (class import)   + �,, 8   r e p e a t   w h i l e   ( c l a s s   i m p o r t )) -.- I  � ��B/�A
�B .sysodelanull��� ��� nmbr/ m   � ��@�@ �A  . 010 l  � ��?23�?  2   end repeat   3 �44    e n d   r e p e a t1 5�>5 l   � ��=67�=  6	
		log "images"
		repeat with image in imageList
			tell application "Finder" to set aName to name of image
			log aName
		end repeat
		log "medias"
		repeat with media in mediaList
			log (get the filename of media)
		end repeat
		log (count of mediaList)
		   7 �88 
 	 	 l o g   " i m a g e s " 
 	 	 r e p e a t   w i t h   i m a g e   i n   i m a g e L i s t 
 	 	 	 t e l l   a p p l i c a t i o n   " F i n d e r "   t o   s e t   a N a m e   t o   n a m e   o f   i m a g e 
 	 	 	 l o g   a N a m e 
 	 	 e n d   r e p e a t 
 	 	 l o g   " m e d i a s " 
 	 	 r e p e a t   w i t h   m e d i a   i n   m e d i a L i s t 
 	 	 	 l o g   ( g e t   t h e   f i l e n a m e   o f   m e d i a ) 
 	 	 e n d   r e p e a t 
 	 	 l o g   ( c o u n t   o f   m e d i a L i s t ) 
 	 	�>   � 5    �<9�;
�< 
capp9 m    :: �;;   c o m . a p p l e . p h o t o s
�; kfrmID  �}   � <=< l     �:�9�8�:  �9  �8  = >?> l     �7�6�5�7  �6  �5  ? @A@ l     �4BC�4  B P J Update status flag in session file to tell Lightroom we are finished here   C �DD �   U p d a t e   s t a t u s   f l a g   i n   s e s s i o n   f i l e   t o   t e l l   L i g h t r o o m   w e   a r e   f i n i s h e d   h e r eA EFE i    GHG I      �3I�2�3 &0 updatesessionfile updateSessionFileI JKJ o      �1�1 0 sessionfile sessionFileK LML o      �0�0 0 	albumname 	albumNameM N�/N o      �.�. "0 checkduplicates checkDuplicates�/  �2  H k     %OO PQP I    �-RS
�- .rdwropenshor       fileR o     �,�, 0 sessionfile sessionFileS �+T�*
�+ 
permT m    �)
�) boovtrue�*  Q UVU I   �(WX
�( .rdwrseofnull���     ****W o    	�'�' 0 sessionfile sessionFileX �&Y�%
�& 
set2Y m   
 �$�$  �%  V Z[Z I   �#\]
�# .rdwrwritnull���     ****\ b    ^_^ b    `a` b    bcb b    ded m    ff �gg  a l b u m _ n a m e =e o    �"�" 0 	albumname 	albumNamec m    hh �ii " 
 e x p o r t _ d o n e = t r u ea m    jj �kk $ 
 c h e c k _ d u p l i c a t e s =_ o    �!�! "0 checkduplicates checkDuplicates] � l�
�  
refnl o    �� 0 sessionfile sessionFile�  [ m�m I    %�n�
� .rdwrclosnull���     ****n o     !�� 0 sessionfile sessionFile�  �  F opo l     ����  �  �  p qrq l     ����  �  �  r sts i    uvu I      �w�� 0 getimagelist getImageListw x�x o      �� 0 afolder aFolder�  �  v k     �yy z{z r     [|}| J     Y~~ � m     �� ���  j p g� ��� m    �� ���  p n g� ��� m    �� ���  t i f f� ��� m    �� ���  J P G� ��� m    �� ���  j p e g� ��� m    �� ���  g i f� ��� m    �� ���  J P E G� ��� m    �� ���  P N G� ��� m    	�� ���  T I F F� ��� m   	 
�� ���  G I F� ��� m   
 �� ���  M O V� ��� m    �� ���  m o v� ��� m    �� ���  M P 4� ��� m    �� ���  m p 4� ��� m    �� ���  M 4 V� ��� m    �� ���  m 4 v� ��� m    �� ���  M P G� ��� m    �� ���  m p g� ��� m    �� ���  B M P� ��� m    �� ���  b m p� ��� m    �� ���  T I F� ��� m    "�� ���  t i f� ��� m   " %�� ���  A V I� ��� m   % (�� ���  a v i� ��� m   ( +�� ���  P S D� ��� m   + .�� ���  p s d� ��� m   . 1�� ���  a i� ��� m   1 4�� ���  A I� ��� m   4 7�� ���  o r f� ��� m   7 :�� ���  O R F� ��� m   : =�� ���  n e f� ��� m   = @�� ���  N E F� � � m   @ C �  c r w   m   C F �  C R W  m   F I		 �

  c r 2  m   I L �  C R 2  m   L O �  d n g  m   O R �  D N G � m   R U �  P E F�  } o      ��  0 extensionslist extensionsList{  t   \ � O  d  r   j ~ !  6  j |"#" n   j o$%$ 2   k o�
� 
file% o   j k�� 0 afolder aFolder# E  r {&'& o   s u��  0 extensionslist extensionsList' 1   v z�

�
 
nmxt! o      �	�	 0 thefiles theFiles m   d g((�                                                                                  MACS  alis    4  00 Mac                         BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p    0 0   M a c  &System/Library/CoreServices/Finder.app  / ��   l  \ c)��) ]   \ c*+* m   \ _�� + m   _ b�� <�  �   ,-, r   � �./. J   � ���  / o      �� 0 	imagelist 	imageList- 010 Y   � �2�34�2 k   � �55 676 r   � �898 c   � �:;: n   � �<=< 4   � �� >
�  
cobj> o   � ����� 0 i  = o   � ����� 0 thefiles theFiles; m   � ���
�� 
alis9 o      ���� 0 thisitem thisItem7 ?��? r   � �@A@ o   � ����� 0 thisitem thisItemA l     B����B n      CDC  ;   � �D o   � ����� 0 	imagelist 	imageList��  ��  ��  � 0 i  3 m   � ����� 4 n   � �EFE m   � ���
�� 
nmbrF n  � �GHG 2  � ���
�� 
cobjH o   � ����� 0 thefiles theFiles�  1 IJI l  � ���������  ��  ��  J K��K o   � ����� 0 	imagelist 	imageList��  t LML l     ��������  ��  ��  M NON l     ��������  ��  ��  O PQP l     ��RS��  R   Run the import script   S �TT ,   R u n   t h e   i m p o r t   s c r i p tQ UVU i    WXW I     ��Y��
�� .aevtoappnull  �   � ****Y o      ���� 0 argv  ��  X k     TZZ [\[ Z     ]^����] l    _����_ =     `a` o     ���� 0 argv  a  f    ��  ��  ^ r    bcb J    	dd e��e m    ff �gg B / U s e r s / d i e t e r s t o c k h a u s e n / T e m p / a a a��  c o      ���� 0 argv  ��  ��  \ hih l   ��jk��  j D > Read the directory from the input and define the session file   k �ll |   R e a d   t h e   d i r e c t o r y   f r o m   t h e   i n p u t   a n d   d e f i n e   t h e   s e s s i o n   f i l ei mnm r    opo n    qrq 4    ��s
�� 
cobjs m    ���� r o    ���� 0 argv  p o      ���� 0 
tempfolder 
tempFoldern tut r    vwv b    xyx o    ���� 0 
tempfolder 
tempFoldery m    zz �{{  / s e s s i o n . t x tw o      ���� 0 sessionfile sessionFileu |}| l   ��~��  ~ . ( Scan the session file for an album name    ��� P   S c a n   t h e   s e s s i o n   f i l e   f o r   a n   a l b u m   n a m e} ��� I   "�����
�� .rdwropenshor       file� o    ���� 0 sessionfile sessionFile��  � ��� r   # *��� l  # (������ I  # (�����
�� .rdwrread****        ****� o   # $���� 0 sessionfile sessionFile��  ��  ��  � o      ���� "0 sessioncontents sessionContents� ��� I  + 0�����
�� .rdwrclosnull���     ****� o   + ,���� 0 sessionfile sessionFile��  � ��� r   1 9��� I   1 7������� 00 extractcheckduplicates extractCheckDuplicates� ���� o   2 3���� "0 sessioncontents sessionContents��  ��  � o      ���� "0 checkduplicates checkDuplicates� ��� l  : :��������  ��  ��  � ��� r   : B��� I   : @������� $0 extractalbumname extractAlbumName� ���� o   ; <���� "0 sessioncontents sessionContents��  ��  � o      ���� 0 	albumname 	albumName� ��� I   C K������� 
0 import  � ��� o   D E���� 0 
tempfolder 
tempFolder� ��� o   E F���� 0 	albumname 	albumName� ���� o   F G���� "0 checkduplicates checkDuplicates��  ��  � ���� I   L T������� &0 updatesessionfile updateSessionFile� ��� o   M N���� 0 sessionfile sessionFile� ��� o   N O���� 0 	albumname 	albumName� ���� o   O P���� "0 checkduplicates checkDuplicates��  ��  ��  V ���� l     ��������  ��  ��  ��       �����������  � �������������� $0 extractalbumname extractAlbumName�� 00 extractcheckduplicates extractCheckDuplicates�� 
0 import  �� &0 updatesessionfile updateSessionFile�� 0 getimagelist getImageList
�� .aevtoappnull  �   � ****� �� ���������� $0 extractalbumname extractAlbumName�� ����� �  ���� "0 sessioncontents sessionContents��  � �������������� "0 sessioncontents sessionContents�� 0 	albumname 	albumName�� 0 alllines allLines�� 0 aline aLine�� "0 equalsignoffset equalSignOffset�� 0 var  �  ���������� .�������� G V
�� 
cpar
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
psof
�� 
psin�� 
�� .sysooffslong    ��� null
�� 
ctxt�� j�E�O��-E�O [�[��l kh *���� 	E�O�j 6�[�\[Zk\Z�k2E�O��  �[�\[Z*���� 	k\Zi2E�Y hY h[OY��O�� �� e���������� 00 extractcheckduplicates extractCheckDuplicates�� ����� �  ���� "0 sessioncontents sessionContents��  � �������������� "0 sessioncontents sessionContents�� "0 checkduplicates checkDuplicates�� 0 alllines allLines�� 0 aline aLine�� ,0 checkuplicatesastext checkuplicatesAsText�� 0 e  � ��������~ � ��}�|�{ ��z�y�x � ��w �
�� 
cpar
�� 
kocl
�� 
cobj
� .corecnte****       ****
�~ 
pcnt
�} 
ascr
�| 
txdl
�{ 
citm
�z 
bool�y 0 e  �x  
�w .ascrcmnt****      � ****�� pfE�O��-E�O Y�[��l kh  2��,� &���,FO��k/�  ��l/E�O��&E�OY hY hW X  �%�%j OfE�[OY��Oa ��,FO�� �v ��u�t���s�v 
0 import  �u �r��r �  �q�p�o�q 0 sourcefolder sourceFolder�p 0 	albumname 	albumName�o "0 checkduplicates checkDuplicates�t  � 
�n�m�l�k�j�i�h�g�f�e�n 0 sourcefolder sourceFolder�m 0 	albumname 	albumName�l "0 checkduplicates checkDuplicates�k 0 thepath thePath�j 0 	thefolder 	theFolder�i 0 	imagelist 	imageList�h 0 	medialist 	mediaList�g 0 lralbum lrAlbum�f 	0 image  �e 0 	shortlist 	shortList� �d�c�b�a:�` ��_�^�]�\�[�Z�Y�X�W�V�U�T�S
�d 
psxf
�c 
alis�b 0 getimagelist getImageList
�a 
capp
�` kfrmID  
�_ .IPXSimponull���     ****
�^ 
skDU
�] 
IPal
�\ .coredoexnull���     ****
�[ 
kocl
�Z 
naME�Y 
�X .corecrel****      � null
�W 
toAl
�V 
IPct
�U 
cobj
�T .corecnte****       ****
�S .sysodelanull��� ��� nmbr�s �*�/�&E�O�E�O*�k+ E�O)���0 ���  �e  �j E�Y ��el E�Y b*�/j 
 *���� E�Y hO�e  ��*a �/l E�Y / ,�[�a l kh �kvE�O��*a �/�e� E�[OY��Olj OPU� �RH�Q�P���O�R &0 updatesessionfile updateSessionFile�Q �N��N �  �M�L�K�M 0 sessionfile sessionFile�L 0 	albumname 	albumName�K "0 checkduplicates checkDuplicates�P  � �J�I�H�J 0 sessionfile sessionFile�I 0 	albumname 	albumName�H "0 checkduplicates checkDuplicates� 
�G�F�E�Dfhj�C�B�A
�G 
perm
�F .rdwropenshor       file
�E 
set2
�D .rdwrseofnull���     ****
�C 
refn
�B .rdwrwritnull���     ****
�A .rdwrclosnull���     ****�O &��el O��jl O�%�%�%�%�l O�j 	� �@v�?�>���=�@ 0 getimagelist getImageList�? �<��< �  �;�; 0 afolder aFolder�>  � �:�9�8�7�6�5�: 0 afolder aFolder�9  0 extensionslist extensionsList�8 0 thefiles theFiles�7 0 	imagelist 	imageList�6 0 i  �5 0 thisitem thisItem� 1��������������������������������	�4�3�2(�1��0�/�.�-�4 '�3 �2 <
�1 
file�  
�0 
nmxt
�/ 
cobj
�. 
nmbr
�- 
alis�= �����������������a a a a a a a a a a a a a a a a a  a !a "a #a $a %a &a 'vE�Oa (a ) na * �a +-a ,[Z�\a -,@1E�UoOjvE�O (k�a .-a /,Ekh �a .�/a 0&E�O��6F[OY��O�� �,X�+�*���)
�, .aevtoappnull  �   � ****�+ 0 argv  �*  � �(�( 0 argv  � f�'�&z�%�$�#�"�!� �����
�' 
cobj�& 0 
tempfolder 
tempFolder�% 0 sessionfile sessionFile
�$ .rdwropenshor       file
�# .rdwrread****        ****�" "0 sessioncontents sessionContents
�! .rdwrclosnull���     ****�  00 extractcheckduplicates extractCheckDuplicates� "0 checkduplicates checkDuplicates� $0 extractalbumname extractAlbumName� 0 	albumname 	albumName� 
0 import  � &0 updatesessionfile updateSessionFile�) U�)  
�kvE�Y hO��k/E�O��%E�O�j O�j E�O�j O*�k+ 	E�O*�k+ E�O*���m+ O*���m+ ascr  ��ޭ