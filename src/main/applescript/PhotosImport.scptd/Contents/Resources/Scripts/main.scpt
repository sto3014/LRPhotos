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
0 photos  � �� � o      ���� 0 	albumname 	albumName�   �  } k    E�� ��� r     ��� m     �� ���  :� n     ��� 1    ��
�� 
txdl� 1    ��
�� 
ascr� ��� l   ��������  ��  ��  � ��� O   :��� k   9�� ��� r    ��� J    ����  � o      ����  0 importedphotos importedPhotos� ��� l   ��������  ��  ��  � ��� l   ������  �   create trashAlbum   � ��� $   c r e a t e   t r a s h A l b u m� ��� Z    2������ I   �����
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
�� .ascrcmnt****      � ****� o   S T���� 0 importalbum importAlbum��  � ��� X   Y3����� k   i.�� ��� l  i i������  �   the file path   � ���    t h e   f i l e   p a t h� ��� r   i q��� n   i o��� 4   j o���
�� 
citm� m   m n���� � o   i j���� (0 thephotodescriptor thePhotoDescriptor� o      ���� 0 thephotofile thePhotoFile� ��� l  r r������  � E ? the LR id. Not used here, but necessary for the way back to LR   � ��� ~   t h e   L R   i d .   N o t   u s e d   h e r e ,   b u t   n e c e s s a r y   f o r   t h e   w a y   b a c k   t o   L R� ��� r   r z��� n   r x��� 4   s x���
�� 
citm� m   v w���� � o   r s���� (0 thephotodescriptor thePhotoDescriptor� o      ���� 0 lrid lrId� ��� l  { {������  �   used as keyword   � ���     u s e d   a s   k e y w o r d� ��� r   { ���� n   { ���� 4   | ����
�� 
citm� m    ����� � o   { |���� (0 thephotodescriptor thePhotoDescriptor� o      ���� 0 lrcat lrCat� ��� l  � �������  � . ( if exists a Photos id, it is an update.   � ��� P   i f   e x i s t s   a   P h o t o s   i d ,   i t   i s   a n   u p d a t e .� ��� r   � ���� m   � ���
�� boovfals� o      ���� 0 isupdate isUpdate� ��� Q   � ������ k   � ��� ��� r   � �   n   � � 4   � ���
�� 
citm m   � �����  o   � ����� (0 thephotodescriptor thePhotoDescriptor o      ���� 0 photosid photosId� �� r   � � m   � ���
�� boovtrue o      ���� 0 isupdate isUpdate��  � R      ������
�� .ascrerr ****      � ****��  ��  ��  � 	 l  � ���������  ��  ��  	 

 r   � � J   � �����   o      ���� (0 previousalbumnames previousAlbumNames  r   � � J   � �����   o      ���� 0 
mediaitems 
mediaItems  l  � ���������  ��  ��    l  � �����   b \ if photosId is set, the LR photo was imported before and this should be moved to trashAlbum    � �   i f   p h o t o s I d   i s   s e t ,   t h e   L R   p h o t o   w a s   i m p o r t e d   b e f o r e   a n d   t h i s   s h o u l d   b e   m o v e d   t o   t r a s h A l b u m  Z   �:���� =  � � o   � ����� 0 isupdate isUpdate m   � ���
�� boovtrue k   �6  !  r   � �"#" l  � �$����$ 6  � �%&% 2   � ���
�� 
IPmi& =  � �'(' 1   � ���
�� 
ID  ( o   � ����� 0 photosid photosId��  ��  # o      ����  0 previousphotos previousPhotos! )��) Z   �6*+��,* ?  � �-.- l  � �/����/ I  � ���0��
�� .corecnte****       ****0 o   � �����  0 previousphotos previousPhotos��  ��  ��  . m   � �����  + k   �011 232 r   � �454 n   � �676 1   � ���
�� 
pnam7 l  � �8����8 6  � �9:9 2  � ���
�� 
IPal: E   � �;<; n   � �=>= 1   � ���
�� 
ID  > 2  � ���
�� 
IPmi< o   � ����� 0 photosid photosId��  ��  5 o      ���� (0 previousalbumnames previousAlbumNames3 ?@? I  � ���AB
�� .IPXSaddpnull���     ****A o   � �����  0 previousphotos previousPhotosB ��C��
�� 
toAlC 4   � ���D
�� 
IPalD o   � �����  0 trashalbumname trashAlbumName��  @ EFE r   � �GHG n   � �IJI 4   � ���K
�� 
cobjK m   � ����� J o   � �����  0 previousphotos previousPhotosH o      ���� $0 thepreviousphoto thePreviousPhotoF LML l  � ��NO�  N    set the photo out-of-date   O �PP 4   s e t   t h e   p h o t o   o u t - o f - d a t eM QRQ r   �STS J   �UU V�~V m   �WW �XX  l r : o u t - o f - d a t e�~  T o      �}�} 0 newkeywords newKeywordsR YZY r  [\[ l ]�|�{] n  ^_^ 1  �z
�z 
IPkw_ o  �y�y $0 thepreviousphoto thePreviousPhoto�|  �{  \ o      �x�x 0 thesekeywords theseKeywordsZ `�w` Z  0ab�vca = ded o  �u�u 0 thesekeywords theseKeywordse m  �t
�t 
msngb r  "fgf o  �s�s 0 newkeywords newKeywordsg n      hih 1  !�r
�r 
IPkwi o  �q�q $0 thepreviousphoto thePreviousPhoto�v  c r  %0jkj l %*l�p�ol b  %*mnm o  %(�n�n 0 thesekeywords theseKeywordsn o  ()�m�m 0 newkeywords newKeywords�p  �o  k n      opo 1  +/�l
�l 
IPkwp o  *+�k�k $0 thepreviousphoto thePreviousPhoto�w  ��  , k  36qq rsr l 33�jtu�j  t %  happens if photos were deleted   u �vv >   h a p p e n s   i f   p h o t o s   w e r e   d e l e t e ds w�iw r  36xyx m  34�h
�h boovfalsy o      �g�g 0 isupdate isUpdate�i  ��  ��  ��   z{z l ;;�f�e�d�f  �e  �d  { |}| l ;;�c~�c  ~ !  now we import the LR photo    ��� 6   n o w   w e   i m p o r t   t h e   L R   p h o t o} ��� I ;D�b��a
�b .ascrcmnt****      � ****� b  ;@��� m  ;>�� ���  T h e   f i l e :  � o  >?�`�` 0 thephotofile thePhotoFile�a  � ��� Z  Eu���_�� = EH��� o  EF�^�^ 0 isupdate isUpdate� m  FG�]
�] boovtrue� k  KZ�� ��� l KK�\���\  � 6 0 on update, the standard album must me ignored.    � ��� `   o n   u p d a t e ,   t h e   s t a n d a r d   a l b u m   m u s t   m e   i g n o r e d .  � ��� l KK�[���[  � G A later it will  added to the albums of the previous photo version   � ��� �   l a t e r   i t   w i l l     a d d e d   t o   t h e   a l b u m s   o f   t h e   p r e v i o u s   p h o t o   v e r s i o n� ��Z� r  KZ��� I KV�Y��
�Y .IPXSimponull���     ****� J  KN�� ��X� o  KL�W�W 0 thephotofile thePhotoFile�X  � �V��U
�V 
skDU� m  QR�T
�T boovtrue�U  � o      �S�S 0 	newphotos 	newPhotos�Z  �_  � k  ]u�� ��� l ]]�R���R  � . ( if new, it goes into the standard album   � ��� P   i f   n e w ,   i t   g o e s   i n t o   t h e   s t a n d a r d   a l b u m� ��Q� r  ]u��� I ]q�P��
�P .IPXSimponull���     ****� J  ]`�� ��O� o  ]^�N�N 0 thephotofile thePhotoFile�O  � �M��
�M 
toAl� 4  ci�L�
�L 
IPct� o  gh�K�K "0 importalbumname importAlbumName� �J��I
�J 
skDU� m  lm�H
�H boovtrue�I  � o      �G�G 0 	newphotos 	newPhotos�Q  � ��� l vv�F�E�D�F  �E  �D  � ��� l vv�C���C  � &   put it into the previous albums   � ��� @   p u t   i t   i n t o   t h e   p r e v i o u s   a l b u m s� ��� Z  v����B�A� = vy��� o  vw�@�@ 0 isupdate isUpdate� m  wx�?
�? boovtrue� X  |���>�� I ���=��
�= .IPXSaddpnull���     ****� o  ���<�< 0 	newphotos 	newPhotos� �;��:
�; 
toAl� 4  ���9�
�9 
IPal� o  ���8�8 0 	albumname 	albumName�:  �> 0 	albumname 	albumName� o  ��7�7 (0 previousalbumnames previousAlbumNames�B  �A  � ��� l ���6���6  �       � ���     � ��� l ���5���5  �   Update metadata   � ���     U p d a t e   m e t a d a t a� ��4� Z  �.���3�2� ? ����� l ����1�0� I ���/��.
�/ .corecnte****       ****� o  ���-�- 0 	newphotos 	newPhotos�.  �1  �0  � m  ���,�,  � k  �*�� ��� l ���+���+  � * $ set the name of the LR catalog file   � ��� H   s e t   t h e   n a m e   o f   t h e   L R   c a t a l o g   f i l e� ��� r  ����� J  ���� ��*� b  ����� b  ����� m  ���� ���  l r :� o  ���)�) 0 lrcat lrCat� m  ���� ���  . l r c a t�*  � o      �(�( 0 newkeywords newKeywords� ��� r  ����� n  ����� 4  ���'�
�' 
cobj� m  ���&�& � o  ���%�% 0 	newphotos 	newPhotos� o      �$�$ 0 thenewphoto theNewPhoto� ��� r  ����� l ����#�"� n  ����� 1  ���!
�! 
IPkw� o  ��� �  0 thenewphoto theNewPhoto�#  �"  � o      �� 0 thesekeywords theseKeywords� ��� Z  ������� = ����� o  ���� 0 thesekeywords theseKeywords� m  ���
� 
msng� r  ��   o  ���� 0 newkeywords newKeywords n       1  ���
� 
IPkw o  ���� 0 thenewphoto theNewPhoto�  � r  �� l ���� b  �� o  ���� 0 thesekeywords theseKeywords o  ���� 0 newkeywords newKeywords�  �   n      	
	 1  ���
� 
IPkw
 o  ���� 0 thenewphoto theNewPhoto�  l ����     store the id for LR    � (   s t o r e   t h e   i d   f o r   L R  r  � e  � l ��� n  � 1  � �
� 
ID   o  ���� 0 thenewphoto theNewPhoto�  �   o      �� 0 photosid photosId  r   b   b   b   !  b  "#" b  $%$ b  	&'& o  �� 0 thephotofile thePhotoFile' m  (( �))  :% o  	
�� 0 lrid lrId# m  ** �++  :! o  �
�
 0 lrcat lrCat m  ,, �--  : o  �	�	 0 photosid photosId o      �� 0 newentry newEntry ./. I #�0�
� .ascrcmnt****      � ****0 o  �� 0 newentry newEntry�  / 1�1 s  $*232 o  $'�� 0 newentry newEntry3 l     4��4 n      565  ;  ()6 o  '(� �   0 importedphotos importedPhotos�  �  �  �3  �2  �4  �� (0 thephotodescriptor thePhotoDescriptor� o   \ ]���� 
0 photos  � 7��7 I 49��8��
�� .sysodelanull��� ��� nmbr8 m  45���� ��  ��  � 5    ��9��
�� 
capp9 m    	:: �;;   c o m . a p p l e . p h o t o s
�� kfrmID  � <=< r  ;B>?> m  ;>@@ �AA   ? n     BCB 1  ?A��
�� 
txdlC 1  >?��
�� 
ascr= D��D L  CEEE o  CD����  0 importedphotos importedPhotos��  { FGF l     ��������  ��  ��  G HIH l     ��������  ��  ��  I JKJ l     ��LM��  L P J Update status flag in session file to tell Lightroom we are finished here   M �NN �   U p d a t e   s t a t u s   f l a g   i n   s e s s i o n   f i l e   t o   t e l l   L i g h t r o o m   w e   a r e   f i n i s h e d   h e r eK OPO i    QRQ I      ��S���� &0 updatesessionfile updateSessionFileS TUT o      ���� 0 sessionfile sessionFileU V��V o      ���� 0 	albumname 	albumName��  ��  R k     !WW XYX I    ��Z[
�� .rdwropenshor       fileZ o     ���� 0 sessionfile sessionFile[ ��\��
�� 
perm\ m    ��
�� boovtrue��  Y ]^] I   ��_`
�� .rdwrseofnull���     ****_ o    	���� 0 sessionfile sessionFile` ��a��
�� 
set2a m   
 ����  ��  ^ bcb I   ��de
�� .rdwrwritnull���     ****d b    fgf b    hih m    jj �kk  a l b u m _ n a m e =i o    ���� 0 	albumname 	albumNameg m    ll �mm " 
 e x p o r t _ d o n e = t r u ee ��n��
�� 
refnn o    ���� 0 sessionfile sessionFile��  c o��o I   !��p��
�� .rdwrclosnull���     ****p o    ���� 0 sessionfile sessionFile��  ��  P qrq l     ��������  ��  ��  r sts i    uvu I      ��w���� $0 updatephotosfile updatePhotosFilew xyx o      ���� 0 
photosfile 
photosFiley z��z o      ����  0 importedphotos importedPhotos��  ��  v k     :{{ |}| I    ��~
�� .rdwropenshor       file~ o     ���� 0 
photosfile 
photosFile �����
�� 
perm� m    ��
�� boovtrue��  } ��� I   ����
�� .rdwrseofnull���     ****� o    	���� 0 
photosfile 
photosFile� �����
�� 
set2� m   
 ����  ��  � ��� X    4����� k     /�� ��� I    %�����
�� .ascrcmnt****      � ****� o     !���� 0 thephotofile thePhotoFile��  � ���� I  & /����
�� .rdwrwritnull���     ****� b   & )��� o   & '���� 0 thephotofile thePhotoFile� m   ' (�� ���  
� �����
�� 
refn� o   * +���� 0 
photosfile 
photosFile��  ��  �� 0 thephotofile thePhotoFile� o    ����  0 importedphotos importedPhotos� ���� I  5 :�����
�� .rdwrclosnull���     ****� o   5 6���� 0 
photosfile 
photosFile��  ��  t ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  �   Run the import script   � ��� ,   R u n   t h e   i m p o r t   s c r i p t� ��� i    ��� I     �����
�� .aevtoappnull  �   � ****� o      ���� 0 argv  ��  � k     ��� ��� r     ��� m     �� ��� " I m p o r t   ( L R P h o t o s )� o      ���� "0 importalbumname importAlbumName� ��� r    ��� m    �� ���   T r a s h   ( L R P h o t o s )� o      ����  0 trashalbumname trashAlbumName� ��� l   ��������  ��  ��  � ��� Z    ������� l   ������ =    ��� o    	���� 0 argv  �  f   	 
��  ��  � r    ��� J    �� ���� m    �� ��� T / U s e r s / d i e t e r s t o c k h a u s e n / P i c t u r e s / L R P h o t o s��  � o      ���� 0 argv  ��  ��  � ��� l   ������  � D > Read the directory from the input and define the session file   � ��� |   R e a d   t h e   d i r e c t o r y   f r o m   t h e   i n p u t   a n d   d e f i n e   t h e   s e s s i o n   f i l e� ��� r    ��� n    ��� 4    ���
�� 
cobj� m    ���� � o    ���� 0 argv  � o      ���� 0 
tempfolder 
tempFolder� ��� r    $��� b    "��� o     ���� 0 
tempfolder 
tempFolder� m     !�� ���  / s e s s i o n . t x t� o      ���� 0 sessionfile sessionFile� ��� l  % %������  � . ( Scan the session file for an album name   � ��� P   S c a n   t h e   s e s s i o n   f i l e   f o r   a n   a l b u m   n a m e� ��� I  % *�����
�� .rdwropenshor       file� o   % &���� 0 sessionfile sessionFile��  � ��� r   + 2��� l  + 0������ I  + 0�����
�� .rdwrread****        ****� o   + ,���� 0 sessionfile sessionFile��  ��  ��  � o      ���� "0 sessioncontents sessionContents� ��� I  3 8�����
�� .rdwrclosnull���     ****� o   3 4���� 0 sessionfile sessionFile��  � ��� l  9 9��������  ��  ��  � ��� r   9 A��� I   9 ?������� $0 extractalbumname extractAlbumName� ���� o   : ;���� "0 sessioncontents sessionContents��  ��  � o      ���� 0 	albumname 	albumName� ��� Z  B O������� >  B E��� o   B C���� 0 	albumname 	albumName� m   C D�� ���  � r   H K��� o   H I�� 0 	albumname 	albumName� o      �~�~ "0 importalbumname importAlbumName��  ��  � ��� l  P P�}�|�{�}  �|  �{  � ��� l  P P�z�y�x�z  �y  �x  � ��� r   P Y� � b   P U o   P Q�w�w 0 
tempfolder 
tempFolder m   Q T �  / p h o t o s . t x t  o      �v�v 0 
photosfile 
photosFile�  I  Z a�u�t
�u .rdwropenshor       file o   Z ]�s�s 0 
photosfile 
photosFile�t   	 r   b m

 l  b i�r�q I  b i�p�o
�p .rdwrread****        **** o   b e�n�n 0 
photosfile 
photosFile�o  �r  �q   o      �m�m  0 photoscontents photosContents	  I  n u�l�k
�l .rdwrclosnull���     **** o   n q�j�j 0 
photosfile 
photosFile�k    l  v v�i�h�g�i  �h  �g    r   v � I   v ~�f�e�f 0 extractphotos extractPhotos �d o   w z�c�c  0 photoscontents photosContents�d  �e   o      �b�b 
0 photos    l  � ��a�`�_�a  �`  �_    r   � � I   � ��^�]�^ 
0 import    !  o   � ��\�\ 
0 photos  ! "�[" o   � ��Z�Z 0 	albumname 	albumName�[  �]   o      �Y�Y  0 importedphotos importedPhotos #$# I   � ��X%�W�X $0 updatephotosfile updatePhotosFile% &'& o   � ��V�V 0 
photosfile 
photosFile' (�U( o   � ��T�T  0 importedphotos importedPhotos�U  �W  $ )*) l  � ��S�R�Q�S  �R  �Q  * +�P+ I   � ��O,�N�O &0 updatesessionfile updateSessionFile, -.- o   � ��M�M 0 sessionfile sessionFile. /�L/ o   � ��K�K 0 	albumname 	albumName�L  �N  �P  � 0�J0 l     �I�H�G�I  �H  �G  �J       	�F12345678�F  1 �E�D�C�B�A�@�?�E $0 extractalbumname extractAlbumName�D 0 trimthis trimThis�C 0 extractphotos extractPhotos�B 
0 import  �A &0 updatesessionfile updateSessionFile�@ $0 updatephotosfile updatePhotosFile
�? .aevtoappnull  �   � ****2 �> �=�<9:�;�> $0 extractalbumname extractAlbumName�= �:;�: ;  �9�9 "0 sessioncontents sessionContents�<  9 �8�7�6�5�4�3�8 "0 sessioncontents sessionContents�7 0 	albumname 	albumName�6 0 alllines allLines�5 0 aline aLine�4 "0 equalsignoffset equalSignOffset�3 0 var  :  �2�1�0�/�. 2�-�,�+�* K Z
�2 
cpar
�1 
kocl
�0 
cobj
�/ .corecnte****       ****
�. 
psof
�- 
psin�, 
�+ .sysooffslong    ��� null
�* 
ctxt�; j�E�O��-E�O [�[��l kh *���� 	E�O�j 6�[�\[Zk\Z�k2E�O��  �[�\[Z*���� 	k\Zi2E�Y hY h[OY��O�3 �) f�(�'<=�&�) 0 trimthis trimThis�( �%>�% >  �$�#�"�$  0 pstrsourcetext pstrSourceText�#  0 pstrchartotrim pstrCharToTrim�" &0 pstrtrimdirection pstrTrimDirection�'  < �!� �����!  0 pstrsourcetext pstrSourceText�   0 pstrchartotrim pstrCharToTrim� &0 pstrtrimdirection pstrTrimDirection� 0 strtrimedtext strTrimedText� 0 lloc lLoc� 0 rloc rLoc=  ������������������
�	��������� ����2��
� 
msng
� 
pcls
� 
list
� 
bool
� 
tab 
� 
lnfd
� 
ret 
� 
spac
� 
cha � �
� kfrmID  ���  � � � � �
 �	 � � � 	� 
� /� _�0 � 
�  .corecnte****       ****
�� justrght
�� justleft
�� 
ctxt�&�E�O�� 
 	��,��& s����)���0)���0)���0)���0)���0)���0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0)�a �0a vE�Y hOkE�O�j E�O�a  % h��k 
 ���/�&�kE�[OY��Y hO�a  # h�j 
 ���/�&�kE�[OY��Y hO�� 	a Y �[a \[Z�\Z�2E4 ��C����?@���� 0 extractphotos extractPhotos�� ��A�� A  ����  0 photoscontents photosContents��  ? ����������  0 photoscontents photosContents�� 
0 photos  �� 0 alllines allLines�� 0 aline aLine@ ������������h
�� 
cpar
�� 
kocl
�� 
cobj
�� .corecnte****       ****�� 0 trimthis trimThis
�� .ascrcmnt****      � ****�� CjvE�O��-E�O 3�[��l kh *�eem+ E�O�j O�� 	��6GY h[OY��O�5 ��}����BC���� 
0 import  �� ��D�� D  ������ 
0 photos  �� 0 	albumname 	albumName��  B ������������������������������������������ 
0 photos  �� 0 	albumname 	albumName��  0 importedphotos importedPhotos�� 0 
trashalbum 
trashAlbum�� 0 importalbum importAlbum�� (0 thephotodescriptor thePhotoDescriptor�� 0 thephotofile thePhotoFile�� 0 lrid lrId�� 0 lrcat lrCat�� 0 isupdate isUpdate�� 0 photosid photosId�� (0 previousalbumnames previousAlbumNames�� 0 
mediaitems 
mediaItems��  0 previousphotos previousPhotos�� $0 thepreviousphoto thePreviousPhoto�� 0 newkeywords newKeywords�� 0 thesekeywords theseKeywords�� 0 	newphotos 	newPhotos�� 0 thenewphoto theNewPhoto�� 0 newentry newEntryC (�������:��������������������������������E��������W�������������(*,��@
�� 
ascr
�� 
txdl
�� 
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
citm��  ��  
�� 
IPmiE  
�� 
ID  
�� 
pnam
�� 
toAl
�� .IPXSaddpnull���     ****
�� 
IPkw
�� 
msng
�� 
skDU
�� .IPXSimponull���     ****
�� 
IPct
�� .sysodelanull��� ��� nmbr��F���,FO)���0-jvE�O*��/j  *��/E�Y *����� E�O*��/j  *��/E�Y *����� E�O�j O٠[��l kh �a k/E�O�a l/E�O�a m/E�OfE�O �a �/E�OeE�W X  hOjvE�OjvE�O�e  �*a -a [a ,\Z�81E�O�j j e*�-a [a -a ,\Z�@1a ,E�O�a *��/l O��k/E�Oa kvE�O�a ,E^ O] a   ��a ,FY ] �%�a ,FY fE�Y hOa �%j O�e  �kva el E^ Y �kva *a  �/a e� E^ O�e  ( "�[��l kh ] a *�/l [OY��Y hO] j j a !�%a "%kvE�O] �k/E^ O] a ,E^ O] a   �] a ,FY ] �%] a ,FO] a ,EE�O�a #%�%a $%�%a %%�%E^ O] j O] �6GY h[OY�5Olj &UOa '��,FO�6 ��R����FG���� &0 updatesessionfile updateSessionFile�� ��H�� H  ������ 0 sessionfile sessionFile�� 0 	albumname 	albumName��  F ������ 0 sessionfile sessionFile�� 0 	albumname 	albumNameG 	��������jl������
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****�� "��el O��jl O�%�%�l O�j 7 ��v����IJ���� $0 updatephotosfile updatePhotosFile�� ��K�� K  ������ 0 
photosfile 
photosFile��  0 importedphotos importedPhotos��  I �������� 0 
photosfile 
photosFile��  0 importedphotos importedPhotos�� 0 thephotofile thePhotoFileJ �����������������������
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
[OY��O�j 8 �������LM��
�� .aevtoappnull  �   � ****�� 0 argv  ��  L ���� 0 argv  M �����������������������������~�}�|�{�z�y�x�� "0 importalbumname importAlbumName��  0 trashalbumname trashAlbumName
�� 
cobj�� 0 
tempfolder 
tempFolder�� 0 sessionfile sessionFile
�� .rdwropenshor       file
�� .rdwrread****        ****�� "0 sessioncontents sessionContents
�� .rdwrclosnull���     ****�� $0 extractalbumname extractAlbumName�� 0 	albumname 	albumName� 0 
photosfile 
photosFile�~  0 photoscontents photosContents�} 0 extractphotos extractPhotos�| 
0 photos  �{ 
0 import  �z  0 importedphotos importedPhotos�y $0 updatephotosfile updatePhotosFile�x &0 updatesessionfile updateSessionFile�� ��E�O�E�O�)  
�kvE�Y hO��k/E�O��%E�O�j 	O�j 
E�O�j O*�k+ E�O�� �E�Y hO�a %E` O_ j 	O_ j 
E` O_ j O*_ k+ E` O*_ �l+ E` O*_ _ l+ O*��l+ ascr  ��ޭ