FasdUAS 1.101.10   ��   ��    k             p         �� �� "0 importalbumname importAlbumName  ������  0 trashalbumname trashAlbumName��     	 
 	 l     ��������  ��  ��   
     l     ��������  ��  ��        l     ��  ��    3 - Extract the album name from the session file     �   Z   E x t r a c t   t h e   a l b u m   n a m e   f r o m   t h e   s e s s i o n   f i l e      i         I      �� ���� $0 extractalbumname extractAlbumName   ��  o      ���� "0 sessioncontents sessionContents��  ��    k     i       r         m        �      o      ���� 0 	albumname 	albumName       r    	 ! " ! n     # $ # 2    ��
�� 
cpar $ o    ���� "0 sessioncontents sessionContents " o      ���� 0 alllines allLines    % & % X   
 f '�� ( ' k    a ) )  * + * r    % , - , l   # .���� . I   #���� /
�� .sysooffslong    ��� null��   / �� 0 1
�� 
psof 0 m     2 2 � 3 3  = 1 �� 4��
�� 
psin 4 o    ���� 0 aline aLine��  ��  ��   - o      ���� "0 equalsignoffset equalSignOffset +  5�� 5 Z   & a 6 7���� 6 ?   & ) 8 9 8 o   & '���� "0 equalsignoffset equalSignOffset 9 m   ' (����   7 k   , ] : :  ; < ; r   , ; = > = n   , 9 ? @ ? 7  - 9�� A B
�� 
ctxt A m   1 3����  B l  4 8 C���� C \   4 8 D E D o   5 6���� "0 equalsignoffset equalSignOffset E m   6 7���� ��  ��   @ o   , -���� 0 aline aLine > o      ���� 0 var   <  F�� F Z   < ] G H���� G =   < ? I J I o   < =���� 0 var   J m   = > K K � L L  a l b u m _ n a m e H r   B Y M N M n   B W O P O 7  C W�� Q R
�� 
ctxt Q l  G S S���� S [   G S T U T l  H Q V���� V I  H Q���� W
�� .sysooffslong    ��� null��   W �� X Y
�� 
psof X m   J K Z Z � [ [  = Y �� \��
�� 
psin \ o   L M���� 0 aline aLine��  ��  ��   U m   Q R���� ��  ��   R m   T V������ P o   B C���� 0 aline aLine N o      ���� 0 	albumname 	albumName��  ��  ��  ��  ��  ��  �� 0 aline aLine ( o    ���� 0 alllines allLines &  ]�� ] L   g i ^ ^ o   g h���� 0 	albumname 	albumName��     _ ` _ l     ��������  ��  ��   `  a b a l     ��������  ��  ��   b  c d c i     e f e I      �� g���� 0 trimthis trimThis g  h i h o      ����  0 pstrsourcetext pstrSourceText i  j k j o      ����  0 pstrchartotrim pstrCharToTrim k  l�� l o      ���� &0 pstrtrimdirection pstrTrimDirection��  ��   f k     m m  n o n l     �� p q��   p 4 . http://macscripter.net/viewtopic.php?id=18519    q � r r \   h t t p : / / m a c s c r i p t e r . n e t / v i e w t o p i c . p h p ? i d = 1 8 5 1 9 o  s t s l     �� u v��   u . ( pstrSourceText : The text to be trimmed    v � w w P   p s t r S o u r c e T e x t   :   T h e   t e x t   t o   b e   t r i m m e d t  x y x l     �� z {��   z P J pstrCharToTrim     : A list of characters to trim, or true to use default    { � | | �   p s t r C h a r T o T r i m           :   A   l i s t   o f   c h a r a c t e r s   t o   t r i m ,   o r   t r u e   t o   u s e   d e f a u l t y  } ~ } l     ��  ���    N H pstrTrimDirection : Direction of Trim left, right or any value for full    � � � � �   p s t r T r i m D i r e c t i o n   :   D i r e c t i o n   o f   T r i m   l e f t ,   r i g h t   o r   a n y   v a l u e   f o r   f u l l ~  � � � l     ��������  ��  ��   �  � � � r      � � � o     ����  0 pstrsourcetext pstrSourceText � o      ���� 0 strtrimedtext strTrimedText �  � � � l   ��������  ��  ��   �  � � � l   �� � ���   � , & If undefinied use default whitespaces    � � � � L   I f   u n d e f i n i e d   u s e   d e f a u l t   w h i t e s p a c e s �  � � � Z    � � ����� � G     � � � =    � � � o    ����  0 pstrchartotrim pstrCharToTrim � m    ��
�� 
msng � >  
  � � � n   
  � � � m    ��
�� 
pcls � o   
 ����  0 pstrchartotrim pstrCharToTrim � m    ��
�� 
list � k    � � �  � � � l   �� � ���   � c ] trim tab, newline, return and all the unicode characters from the 'separator space' category    � � � � �   t r i m   t a b ,   n e w l i n e ,   r e t u r n   a n d   a l l   t h e   u n i c o d e   c h a r a c t e r s   f r o m   t h e   ' s e p a r a t o r   s p a c e '   c a t e g o r y �  � � � l   �� � ���   � N H [url]http://www.fileformat.info/info/unicode/category/Zs/list.htm[/url]    � � � � �   [ u r l ] h t t p : / / w w w . f i l e f o r m a t . i n f o / i n f o / u n i c o d e / c a t e g o r y / Z s / l i s t . h t m [ / u r l ] �  ��� � r    � � � � J    � � �  � � � 1    ��
�� 
tab  �  � � � 1    ��
�� 
lnfd �  � � � o    ��
�� 
ret  �  � � � 1    ��
�� 
spac �  � � � 5    �� ���
�� 
cha  � m    ���� �
�� kfrmID   �  � � � 5    "�� ���
�� 
cha  � m     �����
�� kfrmID   �  � � � 5   " '�� ���
�� 
cha  � m   $ %����  
�� kfrmID   �  � � � 5   ' ,�� ���
�� 
cha  � m   ) *���� 
�� kfrmID   �  � � � 5   , 1�� ���
�� 
cha  � m   . /���� 
�� kfrmID   �  � � � 5   1 6�� ���
�� 
cha  � m   3 4���� 
�� kfrmID   �  � � � 5   6 =�� ���
�� 
cha  � m   8 ;���� 
�� kfrmID   �  � � � 5   = D�� ���
�� 
cha  � m   ? B���� 
�� kfrmID   �  � � � 5   D K�� ��
�� 
cha  � m   F I�~�~ 
� kfrmID   �  � � � 5   K R�} ��|
�} 
cha  � m   M P�{�{ 
�| kfrmID   �  � � � 5   R Y�z ��y
�z 
cha  � m   T W�x�x 
�y kfrmID   �  � � � 5   Y `�w ��v
�w 
cha  � m   [ ^�u�u 	
�v kfrmID   �  � � � 5   ` g�t ��s
�t 
cha  � m   b e�r�r 

�s kfrmID   �  � � � 5   g n�q ��p
�q 
cha  � m   i l�o�o /
�p kfrmID   �  � � � 5   n u�n ��m
�n 
cha  � m   p s�l�l _
�m kfrmID   �  ��k � 5   u |�j ��i
�j 
cha  � m   w z�h�h0 
�i kfrmID  �k   � o      �g�g  0 pstrchartotrim pstrCharToTrim��  ��  ��   �  � � � l  � ��f�e�d�f  �e  �d   �  � � � r   � � � � � m   � ��c�c  � o      �b�b 0 lloc lLoc �  � � � r   � � � � � I  � ��a ��`
�a .corecnte****       **** � o   � ��_�_ 0 strtrimedtext strTrimedText�`   � o      �^�^ 0 rloc rLoc �  � � � l  � ��]�\�[�]  �\  �[   �  � � � l  � ��Z � ��Z   � J D- From left to right, get location of first non-whitespace character    � � � � � -   F r o m   l e f t   t o   r i g h t ,   g e t   l o c a t i o n   o f   f i r s t   n o n - w h i t e s p a c e   c h a r a c t e r �  � � � Z   � � � ��Y�X � >  � � � � � o   � ��W�W &0 pstrtrimdirection pstrTrimDirection � m   � ��V
�V justrght � W   � � � � � r   � � � � � [   � � � � � o   � ��U�U 0 lloc lLoc � m   � ��T�T  � o      �S�S 0 lloc lLoc � G   � � �  � =   � � o   � ��R�R 0 lloc lLoc l  � ��Q�P [   � � o   � ��O�O 0 rloc rLoc m   � ��N�N �Q  �P    H   � � E  � � o   � ��M�M  0 pstrchartotrim pstrCharToTrim n   � �	
	 4   � ��L
�L 
cha  o   � ��K�K 0 lloc lLoc
 o   � ��J�J 0 strtrimedtext strTrimedText�Y  �X   �  l  � ��I�H�G�I  �H  �G    l  � ��F�F   I C From right to left, get location of first non-whitespace character    � �   F r o m   r i g h t   t o   l e f t ,   g e t   l o c a t i o n   o f   f i r s t   n o n - w h i t e s p a c e   c h a r a c t e r  Z   � ��E�D >  � � o   � ��C�C &0 pstrtrimdirection pstrTrimDirection m   � ��B
�B justleft W   � � r   � � \   � � o   � ��A�A 0 rloc rLoc m   � ��@�@  o      �?�? 0 rloc rLoc G   � �  =   � �!"! o   � ��>�> 0 rloc rLoc" m   � ��=�=    H   � �## E  � �$%$ o   � ��<�<  0 pstrchartotrim pstrCharToTrim% n   � �&'& 4   � ��;(
�; 
cha ( o   � ��:�: 0 rloc rLoc' o   � ��9�9 0 strtrimedtext strTrimedText�E  �D   )*) l  � ��8�7�6�8  �7  �6  * +�5+ Z   �,-�4., @   � �/0/ o   � ��3�3 0 lloc lLoc0 o   � ��2�2 0 rloc rLoc- L   � �11 m   � �22 �33  �4  . L   �44 n   �565 7  ��178
�1 
ctxt7 o   ��0�0 0 lloc lLoc8 o  �/�/ 0 rloc rLoc6 o   � ��.�. 0 strtrimedtext strTrimedText�5   d 9:9 l     �-�,�+�-  �,  �+  : ;<; l     �*=>�*  = * $ Extract photos from the photos file   > �?? H   E x t r a c t   p h o t o s   f r o m   t h e   p h o t o s   f i l e< @A@ i    BCB I      �)D�(�) 0 extractphotos extractPhotosD E�'E o      �&�&  0 photoscontents photosContents�'  �(  C k     BFF GHG r     IJI J     �%�%  J o      �$�$ 
0 photos  H KLK r    
MNM n    OPO 2    �#
�# 
cparP o    �"�"  0 photoscontents photosContentsN o      �!�! 0 alllines allLinesL QRQ X    ?S� TS k    :UU VWV r    %XYX I    #�Z�� 0 trimthis trimThisZ [\[ o    �� 0 aline aLine\ ]^] m    �
� boovtrue^ _�_ m    �
� boovtrue�  �  Y o      �� 0 aline aLineW `a` I  & +�b�
� .ascrcmnt****      � ****b o   & '�� 0 aline aLine�  a c�c Z   , :de��d >  , /fgf o   , -�� 0 aline aLineg m   - .hh �ii  e s   2 6jkj o   2 3�� 0 aline aLinek l     l��l n      mnm  ;   4 5n o   3 4�� 
0 photos  �  �  �  �  �  �  0 aline aLineT o    �� 0 alllines allLinesR o�o L   @ Bpp o   @ A�� 
0 photos  �  A qrq l     �
�	��
  �	  �  r sts l     ����  �  �  t uvu l     �wx�  w = 7 Import exported photos in a new iPhoto album if needed   x �yy n   I m p o r t   e x p o r t e d   p h o t o s   i n   a   n e w   i P h o t o   a l b u m   i f   n e e d e dv z{z i    |}| I      �~�� 
0 import  ~ � o      �� 
0 photos  � �� � o      ���� 0 	albumname 	albumName�   �  } k    ��� ��� r     ��� m     �� ���  :� n     ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr� ��� l   ��������  ��  ��  � ��� O   ���� k   ��� ��� r    ��� J    ����  � o      ����  0 importedphotos importedPhotos� ��� l   ��������  ��  ��  � ��� l   ������  �   create trashAlbum   � ��� $   c r e a t e   t r a s h A l b u m� ��� Z    2������ I   �����
�� .coredoexnull���     ****� 4    ���
�� 
IPal� o    ����  0 trashalbumname trashAlbumName��  � r    $��� 4    "���
�� 
IPal� o     !����  0 trashalbumname trashAlbumName� o      ���� 0 
trashalbum 
trashAlbum��  � r   ' 2��� I  ' 0�����
�� .corecrel****      � null��  � ����
�� 
kocl� m   ) *��
�� 
IPal� �����
�� 
naME� o   + ,����  0 trashalbumname trashAlbumName��  � o      ���� 0 
trashalbum 
trashAlbum� ��� l  3 3��������  ��  ��  � ��� l  3 3������  �   create importAlbum   � ��� &   c r e a t e   i m p o r t A l b u m� ��� Z   3 R������ I  3 ;�����
�� .coredoexnull���     ****� 4   3 7���
�� 
IPal� o   5 6���� "0 importalbumname importAlbumName��  � r   > D��� 4   > B���
�� 
IPal� o   @ A���� "0 importalbumname importAlbumName� o      ���� 0 importalbum importAlbum��  � r   G R��� I  G P�����
�� .corecrel****      � null��  � ����
�� 
kocl� m   I J��
�� 
IPal� �����
�� 
naME� o   K L���� "0 importalbumname importAlbumName��  � o      ���� 0 importalbum importAlbum� ��� I  S X�����
�� .ascrcmnt****      � ****� o   S T���� 0 importalbum importAlbum��  � ��� X   Y������ k   i��� ��� l  i i������  �   the file path   � ���    t h e   f i l e   p a t h� ��� r   i q��� n   i o��� 4   j o���
�� 
citm� m   m n���� � o   i j���� (0 thephotodescriptor thePhotoDescriptor� o      ���� 0 thephotofile thePhotoFile� ��� l  r r������  � E ? the LR id. Not used here, but necessary for the way back to LR   � ��� ~   t h e   L R   i d .   N o t   u s e d   h e r e ,   b u t   n e c e s s a r y   f o r   t h e   w a y   b a c k   t o   L R� ��� r   r z��� n   r x��� 4   s x���
�� 
citm� m   v w���� � o   r s���� (0 thephotodescriptor thePhotoDescriptor� o      ���� 0 lrid lrId� ��� l  { {������  �   used as keyword   � ���     u s e d   a s   k e y w o r d� ��� r   { ���� n   { ���� 4   | ����
�� 
citm� m    ����� � o   { |���� (0 thephotodescriptor thePhotoDescriptor� o      ���� 0 lrcat lrCat� ��� l  � �������  � . ( existing Photos id, if it is an update.   � ��� P   e x i s t i n g   P h o t o s   i d ,   i f   i t   i s   a n   u p d a t e .� ��� q   � ��� ������ 0 photosid photosId��  � ��� Q   � ������ r   � ���� n   � ���� 4   � ��� 
�� 
citm  m   � ����� � o   � ����� (0 thephotodescriptor thePhotoDescriptor� o      ���� 0 photosid photosId� R      ������
�� .ascrerr ****      � ****��  ��  ��  �  l  � ���������  ��  ��    l  � �����   b \ if photosId is set, the LR photo was imported before and this should be moved to trashAlbum    � �   i f   p h o t o s I d   i s   s e t ,   t h e   L R   p h o t o   w a s   i m p o r t e d   b e f o r e   a n d   t h i s   s h o u l d   b e   m o v e d   t o   t r a s h A l b u m 	 Z   � �
����
 >  � � o   � ����� 0 photosid photosId m   � � �   k   � �  r   � � n   � � 1   � ���
�� 
pnam l  � ����� 6  � � 2  � ���
�� 
IPal E   � � n   � � 1   � ���
�� 
ID   2  � ���
�� 
IPmi o   � ����� 0 photosid photosId��  ��   o      ���� 0 
thesenames 
theseNames  r   � � !  l  � �"����" 6  � �#$# 2   � ���
�� 
IPmi$ =  � �%&% 1   � ���
�� 
ID  & o   � ����� 0 photosid photosId��  ��  ! o      ���� 0 
mediaitems 
mediaItems '��' Z   � �()����( >  � �*+* o   � ����� 0 
mediaitems 
mediaItems+ J   � �����  ) k   � �,, -.- r   � �/0/ n   � �121 4   � ���3
�� 
cobj3 m   � ����� 2 o   � ����� 0 
mediaitems 
mediaItems0 o      ���� 0 	mediaitem 	mediaItem. 454 r   � �676 J   � �88 9��9 o   � ����� 0 	mediaitem 	mediaItem��  7 o      ���� 0 	shortlist 	shortList5 :��: I  � ���;<
�� .IPXSaddpnull���     ****; o   � ����� 0 	shortlist 	shortList< ��=��
�� 
toAl= 4   � ���>
�� 
IPal> o   � �����  0 trashalbumname trashAlbumName��  ��  ��  ��  ��  ��  ��  	 ?@? l  � ���AB��  A !  now we import the LR photo   B �CC 6   n o w   w e   i m p o r t   t h e   L R   p h o t o@ DED I  � ���F��
�� .ascrcmnt****      � ****F o   � ����� 0 thephotofile thePhotoFile��  E GHG r   IJI J   KK L��L o   ���� 0 thephotofile thePhotoFile��  J o      ���� 0 	shortlist 	shortListH MNM I ��O��
�� .ascrcmnt****      � ****O b  PQP m  	RR �SS  T h e   f i l e :  Q o  	
���� 0 thephotofile thePhotoFile��  N TUT Z  CVW�XV = YZY o  �~�~ 0 photosid photosIdZ m  [[ �\\  W r  ,]^] I *�}_`
�} .IPXSimponull���     ****_ o  �|�| 0 	shortlist 	shortList` �{ab
�{ 
toAla 4  "�zc
�z 
IPctc o   !�y�y "0 importalbumname importAlbumNameb �xd�w
�x 
skDUd m  %&�v
�v boovtrue�w  ^ o      �u�u 0 	medialist 	mediaList�  X r  /Cefe I /A�tgh
�t .IPXSimponull���     ****g o  /0�s�s 0 	shortlist 	shortListh �rij
�r 
toAli 4  39�qk
�q 
IPctk o  78�p�p "0 importalbumname importAlbumNamej �ol�n
�o 
skDUl m  <=�m
�m boovtrue�n  f o      �l�l 0 	medialist 	mediaListU m�km Z  D�no�j�in > DHpqp o  DE�h�h 0 	medialist 	mediaListq J  EG�g�g  o k  K�rr sts l KK�f�e�d�f  �e  �d  t uvu X  K_�c�bw�c  �b 0 	albumname 	albumNamew o  NO�a�a 0 
thesenames 
theseNamesv xyx l ``�`�_�^�`  �_  �^  y z{z l ``�]|}�]  |   set the keywords   } �~~ "   s e t   t h e   k e y w o r d s{ � r  `i��� J  `g�� ��\� b  `e��� m  `c�� ���  l r C a t -� o  cd�[�[ 0 lrcat lrCat�\  � o      �Z�Z 0 newkeywords newKeywords� ��� r  jr��� n  jn��� 4  kn�Y�
�Y 
cobj� m  lm�X�X � o  jk�W�W 0 	medialist 	mediaList� o      �V�V 0 themedia theMedia� ��� r  s~��� l sz��U�T� n  sz��� 1  vz�S
�S 
IPkw� o  sv�R�R 0 themedia theMedia�U  �T  � o      �Q�Q 0 thesekeywords theseKeywords� ��� Z  ����P�� = ���� o  ��O�O 0 thesekeywords theseKeywords� m  ���N
�N 
msng� r  ����� o  ���M�M 0 newkeywords newKeywords� n      ��� 1  ���L
�L 
IPkw� o  ���K�K 0 themedia theMedia�P  � r  ����� l ����J�I� b  ����� o  ���H�H 0 thesekeywords theseKeywords� o  ���G�G 0 newkeywords newKeywords�J  �I  � n      ��� 1  ���F
�F 
IPkw� o  ���E�E 0 themedia theMedia� ��� l ���D���D  �   get the id for LR   � ��� $   g e t   t h e   i d   f o r   L R� ��� r  ����� e  ���� l ����C�B� n  ����� 1  ���A
�A 
ID  � n  ����� 4  ���@�
�@ 
cobj� m  ���?�? � o  ���>�> 0 	medialist 	mediaList�C  �B  � o      �=�= 0 photosid photosId� ��� r  ����� b  ����� b  ����� b  ����� b  ����� b  ����� b  ����� o  ���<�< 0 thephotofile thePhotoFile� m  ���� ���  :� o  ���;�; 0 lrid lrId� m  ���� ���  :� o  ���:�: 0 lrcat lrCat� m  ���� ���  :� o  ���9�9 0 photosid photosId� o      �8�8 0 newentry newEntry� ��� I ���7��6
�7 .ascrcmnt****      � ****� o  ���5�5 0 newentry newEntry�6  � ��4� s  ����� o  ���3�3 0 newentry newEntry� l     ��2�1� n      ���  ;  ��� o  ���0�0  0 importedphotos importedPhotos�2  �1  �4  �j  �i  �k  �� (0 thephotodescriptor thePhotoDescriptor� o   \ ]�/�/ 
0 photos  � ��.� I ���-��,
�- .sysodelanull��� ��� nmbr� m  ���+�+ �,  �.  � 5    �*��)
�* 
capp� m    	�� ���   c o m . a p p l e . p h o t o s
�) kfrmID  � ��� r  ����� m  ���� ���   � n     ��� 1  ���(
�( 
txdl� 1  ���'
�' 
ascr� ��&� L  ���� o  ���%�%  0 importedphotos importedPhotos�&  { ��� l     �$�#�"�$  �#  �"  � ��� l     �!� ��!  �   �  � ��� l     ����  � P J Update status flag in session file to tell Lightroom we are finished here   � ��� �   U p d a t e   s t a t u s   f l a g   i n   s e s s i o n   f i l e   t o   t e l l   L i g h t r o o m   w e   a r e   f i n i s h e d   h e r e� ��� i    ��� I      ���� &0 updatesessionfile updateSessionFile� ��� o      �� 0 sessionfile sessionFile� ��� o      �� 0 	albumname 	albumName�  �  � k     !�� ��� I    ���
� .rdwropenshor       file� o     �� 0 sessionfile sessionFile� ���
� 
perm� m    �
� boovtrue�  � ��� I   � 
� .rdwrseofnull���     ****  o    	�� 0 sessionfile sessionFile ��
� 
set2 m   
 ��  �  �  I   �
� .rdwrwritnull���     **** b     b    	
	 m     �  a l b u m _ n a m e =
 o    �� 0 	albumname 	albumName m     � " 
 e x p o r t _ d o n e = t r u e ��
� 
refn o    �
�
 0 sessionfile sessionFile�   �	 I   !��
� .rdwrclosnull���     **** o    �� 0 sessionfile sessionFile�  �	  �  l     ����  �  �    i     I      ��� $0 updatephotosfile updatePhotosFile  o      � �  0 
photosfile 
photosFile �� o      ����  0 importedphotos importedPhotos��  �   k     :  I    �� 
�� .rdwropenshor       file o     ���� 0 
photosfile 
photosFile  ��!��
�� 
perm! m    ��
�� boovtrue��   "#" I   ��$%
�� .rdwrseofnull���     ****$ o    	���� 0 
photosfile 
photosFile% ��&��
�� 
set2& m   
 ����  ��  # '(' X    4)��*) k     /++ ,-, I    %��.��
�� .ascrcmnt****      � ****. o     !���� 0 thephotofile thePhotoFile��  - /��/ I  & /��01
�� .rdwrwritnull���     ****0 b   & )232 o   & '���� 0 thephotofile thePhotoFile3 m   ' (44 �55  
1 ��6��
�� 
refn6 o   * +���� 0 
photosfile 
photosFile��  ��  �� 0 thephotofile thePhotoFile* o    ����  0 importedphotos importedPhotos( 7��7 I  5 :��8��
�� .rdwrclosnull���     ****8 o   5 6���� 0 
photosfile 
photosFile��  ��   9:9 l     ��������  ��  ��  : ;<; l     ��������  ��  ��  < =>= l     ��?@��  ?   Run the import script   @ �AA ,   R u n   t h e   i m p o r t   s c r i p t> BCB i    DED I     ��F��
�� .aevtoappnull  �   � ****F o      ���� 0 argv  ��  E k     �GG HIH r     JKJ m     LL �MM " I m p o r t   ( L R P h o t o s )K o      ���� "0 importalbumname importAlbumNameI NON r    PQP m    RR �SS   T r a s h   ( L R P h o t o s )Q o      ����  0 trashalbumname trashAlbumNameO TUT l   ��������  ��  ��  U VWV Z    XY����X l   Z����Z =    [\[ o    	���� 0 argv  \  f   	 
��  ��  Y r    ]^] J    __ `��` m    aa �bb T / U s e r s / d i e t e r s t o c k h a u s e n / P i c t u r e s / L R P h o t o s��  ^ o      ���� 0 argv  ��  ��  W cdc l   ��ef��  e D > Read the directory from the input and define the session file   f �gg |   R e a d   t h e   d i r e c t o r y   f r o m   t h e   i n p u t   a n d   d e f i n e   t h e   s e s s i o n   f i l ed hih r    jkj n    lml 4    ��n
�� 
cobjn m    ���� m o    ���� 0 argv  k o      ���� 0 
tempfolder 
tempFolderi opo r    $qrq b    "sts o     ���� 0 
tempfolder 
tempFoldert m     !uu �vv  / s e s s i o n . t x tr o      ���� 0 sessionfile sessionFilep wxw l  % %��yz��  y . ( Scan the session file for an album name   z �{{ P   S c a n   t h e   s e s s i o n   f i l e   f o r   a n   a l b u m   n a m ex |}| I  % *��~��
�� .rdwropenshor       file~ o   % &���� 0 sessionfile sessionFile��  } � r   + 2��� l  + 0������ I  + 0�����
�� .rdwrread****        ****� o   + ,���� 0 sessionfile sessionFile��  ��  ��  � o      ���� "0 sessioncontents sessionContents� ��� I  3 8�����
�� .rdwrclosnull���     ****� o   3 4���� 0 sessionfile sessionFile��  � ��� l  9 9��������  ��  ��  � ��� r   9 A��� I   9 ?������� $0 extractalbumname extractAlbumName� ���� o   : ;���� "0 sessioncontents sessionContents��  ��  � o      ���� 0 	albumname 	albumName� ��� Z  B O������� >  B E��� o   B C���� 0 	albumname 	albumName� m   C D�� ���  � r   H K��� o   H I���� 0 	albumname 	albumName� o      ���� "0 importalbumname importAlbumName��  ��  � ��� l  P P��������  ��  ��  � ��� l  P P��������  ��  ��  � ��� r   P Y��� b   P U��� o   P Q���� 0 
tempfolder 
tempFolder� m   Q T�� ���  / p h o t o s . t x t� o      ���� 0 
photosfile 
photosFile� ��� I  Z a�����
�� .rdwropenshor       file� o   Z ]���� 0 
photosfile 
photosFile��  � ��� r   b m��� l  b i������ I  b i�����
�� .rdwrread****        ****� o   b e���� 0 
photosfile 
photosFile��  ��  ��  � o      ����  0 photoscontents photosContents� ��� I  n u�����
�� .rdwrclosnull���     ****� o   n q���� 0 
photosfile 
photosFile��  � ��� l  v v��������  ��  ��  � ��� r   v ���� I   v ~������� 0 extractphotos extractPhotos� ���� o   w z����  0 photoscontents photosContents��  ��  � o      ���� 
0 photos  � ��� l  � ���������  ��  ��  � ��� r   � ���� I   � �������� 
0 import  � ��� o   � ����� 
0 photos  � ���� o   � ����� 0 	albumname 	albumName��  ��  � o      ����  0 importedphotos importedPhotos� ��� I   � �������� $0 updatephotosfile updatePhotosFile� ��� o   � ����� 0 
photosfile 
photosFile� ���� o   � �����  0 importedphotos importedPhotos��  ��  � ��� l  � ���������  ��  ��  � ���� I   � ����~� &0 updatesessionfile updateSessionFile� ��� o   � ��}�} 0 sessionfile sessionFile� ��|� o   � ��{�{ 0 	albumname 	albumName�|  �~  ��  C ��z� l     �y�x�w�y  �x  �w  �z       	�v���������v  � �u�t�s�r�q�p�o�u $0 extractalbumname extractAlbumName�t 0 trimthis trimThis�s 0 extractphotos extractPhotos�r 
0 import  �q &0 updatesessionfile updateSessionFile�p $0 updatephotosfile updatePhotosFile
�o .aevtoappnull  �   � ****� �n �m�l���k�n $0 extractalbumname extractAlbumName�m �j��j �  �i�i "0 sessioncontents sessionContents�l  � �h�g�f�e�d�c�h "0 sessioncontents sessionContents�g 0 	albumname 	albumName�f 0 alllines allLines�e 0 aline aLine�d "0 equalsignoffset equalSignOffset�c 0 var  �  �b�a�`�_�^ 2�]�\�[�Z K Z
�b 
cpar
�a 
kocl
�` 
cobj
�_ .corecnte****       ****
�^ 
psof
�] 
psin�\ 
�[ .sysooffslong    ��� null
�Z 
ctxt�k j�E�O��-E�O [�[��l kh *���� 	E�O�j 6�[�\[Zk\Z�k2E�O��  �[�\[Z*���� 	k\Zi2E�Y hY h[OY��O�� �Y f�X�W���V�Y 0 trimthis trimThis�X �U��U �  �T�S�R�T  0 pstrsourcetext pstrSourceText�S  0 pstrchartotrim pstrCharToTrim�R &0 pstrtrimdirection pstrTrimDirection�W  � �Q�P�O�N�M�L�Q  0 pstrsourcetext pstrSourceText�P  0 pstrchartotrim pstrCharToTrim�O &0 pstrtrimdirection pstrTrimDirection�N 0 strtrimedtext strTrimedText�M 0 lloc lLoc�L 0 rloc rLoc�  �K�J�I�H�G�F�E�D�C�B�A�@�?�>�=�<�;�:�9�8�7�6�5�4�3�2�1�0�/�.2�-
�K 
msng
�J 
pcls
�I 
list
�H 
bool
�G 
tab 
�F 
lnfd
�E 
ret 
�D 
spac
�C 
cha �B �
�A kfrmID  �@��?  �> �= �< �; �: �9 �8 �7 �6 	�5 
�4 /�3 _�20 �1 
�0 .corecnte****       ****
�/ justrght
�. justleft
�- 
ctxt�V�E�O�� 
 	��,��& s����)���0)���0)���0)���0)���0)���0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0a vE�Y hOkE�O�j E�O�a  % h��k 
 ���/�&�kE�[OY��Y hO�a  # h�j 
 ���/�&�kE�[OY��Y hO�� 	a Y �[a \[Z�\Z�2E� �,C�+�*���)�, 0 extractphotos extractPhotos�+ �(��( �  �'�'  0 photoscontents photosContents�*  � �&�%�$�#�&  0 photoscontents photosContents�% 
0 photos  �$ 0 alllines allLines�# 0 aline aLine� �"�!� ���h
�" 
cpar
�! 
kocl
�  
cobj
� .corecnte****       ****� 0 trimthis trimThis
� .ascrcmnt****      � ****�) CjvE�O��-E�O 3�[��l kh *�eem+ E�O�j O�� 	��6GY h[OY��O�� �}������ 
0 import  � ��� �  ��� 
0 photos  � 0 	albumname 	albumName�  � ������������
�	������� 
0 photos  � 0 	albumname 	albumName�  0 importedphotos importedPhotos� 0 
trashalbum 
trashAlbum� 0 importalbum importAlbum� (0 thephotodescriptor thePhotoDescriptor� 0 thephotofile thePhotoFile� 0 lrid lrId� 0 lrcat lrCat� 0 photosid photosId� 0 
thesenames 
theseNames�
 0 
mediaitems 
mediaItems�	 0 	mediaitem 	mediaItem� 0 	shortlist 	shortList� 0 	medialist 	mediaList� 0 newkeywords newKeywords� 0 themedia theMedia� 0 thesekeywords theseKeywords� 0 newentry newEntry� (���� ������������������������������������������R[�����������������
� 
ascr
� 
txdl
�  
capp
�� kfrmID  
�� 
IPal��  0 trashalbumname trashAlbumName
�� .coredoexnull���     ****
�� 
kocl
�� 
naME�� 
�� .corecrel****      � null�� "0 importalbumname importAlbumName
�� .ascrcmnt****      � ****
�� 
cobj
�� .corecnte****       ****
�� 
citm��  ��  �  
�� 
IPmi
�� 
ID  
�� 
pnam
�� 
toAl
�� .IPXSaddpnull���     ****
�� 
IPct
�� 
skDU
�� .IPXSimponull���     ****
�� 
IPkw
�� 
msng
�� .sysodelanull��� ��� nmbr�����,FO)���0�jvE�O*��/j  *��/E�Y *����� E�O*��/j  *��/E�Y *����� E�O�j O��[��l kh �a k/E�O�a l/E�O�a m/E�O �a �/E�W X  hO�a  Y*�-a [a -a ,\Z�@1a ,E�O*a -a [a ,\Z�81E�O�jv ��k/E�O�kvE�O�a *��/l Y hY hO�j O�kvE�Oa �%j O�a   �a *a �/a e� E�Y �a *a �/a e� E�O�jv � �[��l kh hY��Oa  �%kvE�O��k/E^ O] a !,E^ O] a "  �] a !,FY ] �%] a !,FO��k/a ,EE�O�a #%�%a $%�%a %%�%E^ O] j O] �6GY h[OY��Olj &UOa '��,FO�� ������������� &0 updatesessionfile updateSessionFile�� ����� �  ������ 0 sessionfile sessionFile�� 0 	albumname 	albumName��  � ������ 0 sessionfile sessionFile�� 0 	albumname 	albumName� 	��������������
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****�� "��el O��jl O�%�%�l O�j � ������������ $0 updatephotosfile updatePhotosFile�� ����� �  ������ 0 
photosfile 
photosFile��  0 importedphotos importedPhotos��  � �������� 0 
photosfile 
photosFile��  0 importedphotos importedPhotos�� 0 thephotofile thePhotoFile� ����������������4������
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� .ascrcmnt****      � ****
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****�� ;��el O��jl O #�[��l kh �j O��%�l 
[OY��O�j � ��E��������
�� .aevtoappnull  �   � ****�� 0 argv  ��  � ���� 0 argv  � L��R��a����u���������������������������������� "0 importalbumname importAlbumName��  0 trashalbumname trashAlbumName
�� 
cobj�� 0 
tempfolder 
tempFolder�� 0 sessionfile sessionFile
�� .rdwropenshor       file
�� .rdwrread****        ****�� "0 sessioncontents sessionContents
�� .rdwrclosnull���     ****�� $0 extractalbumname extractAlbumName�� 0 	albumname 	albumName�� 0 
photosfile 
photosFile��  0 photoscontents photosContents�� 0 extractphotos extractPhotos�� 
0 photos  �� 
0 import  ��  0 importedphotos importedPhotos�� $0 updatephotosfile updatePhotosFile�� &0 updatesessionfile updateSessionFile�� ��E�O�E�O�)  
�kvE�Y hO��k/E�O��%E�O�j 	O�j 
E�O�j O*�k+ E�O�� �E�Y hO�a %E` O_ j 	O_ j 
E` O_ j O*_ k+ E` O*_ �l+ E` O*_ _ l+ O*��l+  ascr  ��ޭ