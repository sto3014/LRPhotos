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
psin X o   L M���� 0 aline aLine��  ��  ��   Q m   Q R���� ��  ��   N m   T V������ L o   B C���� 0 aline aLine J o      ���� 0 	albumname 	albumName��  ��  ��  ��  ��  ��  �� 0 aline aLine $ o    ���� 0 alllines allLines "  Y�� Y L   g i Z Z o   g h���� 0 	albumname 	albumName��     [ \ [ l     ��������  ��  ��   \  ] ^ ] l     ��������  ��  ��   ^  _ ` _ l     �� a b��   a = 7 Import exported photos in a new iPhoto album if needed    b � c c n   I m p o r t   e x p o r t e d   p h o t o s   i n   a   n e w   i P h o t o   a l b u m   i f   n e e d e d `  d e d i     f g f I      �� h���� 
0 import   h  i j i o      ���� 0 sourcefolder sourceFolder j  k�� k o      ���� 0 	albumname 	albumName��  ��   g k     a l l  m n m r      o p o c      q r q 4     �� s
�� 
psxf s o    ���� 0 sourcefolder sourceFolder r m    ��
�� 
alis p o      ���� 0 thepath thePath n  t u t r   	  v w v o   	 
���� 0 thepath thePath w o      ���� 0 	thefolder 	theFolder u  x y x r     z { z I    �� |���� 0 getimagelist getImageList |  }�� } o    ���� 0 	thefolder 	theFolder��  ��   { o      ���� 0 	imagelist 	imageList y  ~�� ~ O    a  �  k    ` � �  � � � Z    X � ��� � � =   ! � � � o    ���� 0 	albumname 	albumName � m      � � � � �   � I  $ +�� � �
�� .IPXSimponull���     **** � o   $ %���� 0 sourcefolder sourceFolder � �� ���
�� 
skDU � m   & '��
�� boovtrue��  ��   � k   . X � �  � � � Z   . I � ����� � H   . 7 � � l  . 6 ����� � I  . 6�� ���
�� .coredoexnull���     **** � 4   . 2�� �
�� 
IPal � o   0 1���� 0 	albumname 	albumName��  ��  ��   � r   : E � � � I  : C���� �
�� .corecrel****      � null��   � �� � �
�� 
kocl � m   < =��
�� 
IPal � �� ���
�� 
naME � o   > ?���� 0 	albumname 	albumName��   � o      ���� 0 lralbum lrAlbum��  ��   �  ��� � I  J X�� � �
�� .IPXSimponull���     **** � o   J K���� 0 	imagelist 	imageList � �� � �
�� 
toAl � 4   L R�� �
�� 
IPct � o   P Q���� 0 	albumname 	albumName � �� ���
�� 
skDU � m   S T��
�� boovtrue��  ��   �  � � � l  Y Y�� � ���   � "  repeat while (class import)    � � � � 8   r e p e a t   w h i l e   ( c l a s s   i m p o r t ) �  � � � I  Y ^�� ���
�� .sysodelanull��� ��� nmbr � m   Y Z���� ��   �  ��� � l  _ _�� � ���   �   end repeat    � � � �    e n d   r e p e a t��   � 5    �� ���
�� 
capp � m     � � � � �   c o m . a p p l e . p h o t o s
�� kfrmID  ��   e  � � � l     ��������  ��  ��   �  � � � l     ��~�}�  �~  �}   �  � � � l     �| � ��|   � P J Update status flag in session file to tell Lightroom we are finished here    � � � � �   U p d a t e   s t a t u s   f l a g   i n   s e s s i o n   f i l e   t o   t e l l   L i g h t r o o m   w e   a r e   f i n i s h e d   h e r e �  � � � i     � � � I      �{ ��z�{ &0 updatesessionfile updateSessionFile �  ��y � o      �x�x 0 sessionfile sessionFile�y  �z   � k      � �  � � � I    �w � �
�w .rdwropenshor       file � o     �v�v 0 sessionfile sessionFile � �u ��t
�u 
perm � m    �s
�s boovtrue�t   �  � � � I   �r � �
�r .rdwrseofnull���     **** � o    	�q�q 0 sessionfile sessionFile � �p ��o
�p 
set2 � m   
 �n�n  �o   �  � � � I   �m � �
�m .rdwrwritnull���     **** � m     � � � � � 8 a l b u m _ n a m e = 
 e x p o r t _ d o n e = t r u e � �l ��k
�l 
refn � o    �j�j 0 sessionfile sessionFile�k   �  ��i � I   �h ��g
�h .rdwrclosnull���     **** � o    �f�f 0 sessionfile sessionFile�g  �i   �  � � � l     �e�d�c�e  �d  �c   �  � � � i     � � � I      �b ��a�b 0 getimagelist getImageList �  ��` � o      �_�_ 0 afolder aFolder�`  �a   � k     � � �  � � � r     [ � � � J     Y � �  � � � m      � � � � �  j p g �  � � � m     � � � � �  p n g �  � � � m     � � � � �  t i f f �  � � � m     � � � � �  J P G �  � � � m     � � � � �  j p e g �  � � � m     � � � � �  g i f �  � � � m     � � � � �  J P E G �    m     �  P N G  m    	 �  T I F F 	 m   	 


 �  G I F	  m   
  �  M O V  m     �  m o v  m     �  M P 4  m     �  m p 4  m     �  M 4 V  !  m    "" �##  m 4 v! $%$ m    && �''  M P G% ()( m    ** �++  m p g) ,-, m    .. �//  B M P- 010 m    22 �33  b m p1 454 m    66 �77  T I F5 898 m    ":: �;;  t i f9 <=< m   " %>> �??  A V I= @A@ m   % (BB �CC  a v iA DED m   ( +FF �GG  P S DE HIH m   + .JJ �KK  p s dI LML m   . 1NN �OO  a iM PQP m   1 4RR �SS  A IQ TUT m   4 7VV �WW  o r fU XYX m   7 :ZZ �[[  O R FY \]\ m   : =^^ �__  n e f] `a` m   = @bb �cc  N E Fa ded m   @ Cff �gg  c r we hih m   C Fjj �kk  C R Wi lml m   F Inn �oo  c r 2m pqp m   I Lrr �ss  C R 2q tut m   L Ovv �ww  d n gu xyx m   O Rzz �{{  D N Gy |�^| m   R U}} �~~  P E F�^   � o      �]�]  0 extensionslist extensionsList � � t   \ ���� O  d ��� r   j ~��� 6  j |��� n   j o��� 2   k o�\
�\ 
file� o   j k�[�[ 0 afolder aFolder� E  r {��� o   s u�Z�Z  0 extensionslist extensionsList� 1   v z�Y
�Y 
nmxt� o      �X�X 0 thefiles theFiles� m   d g���                                                                                  MACS  alis    4  00 Mac                         BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p    0 0   M a c  &System/Library/CoreServices/Finder.app  / ��  � l  \ c��W�V� ]   \ c��� m   \ _�U�U � m   _ b�T�T <�W  �V  � ��� r   � ���� J   � ��S�S  � o      �R�R 0 	imagelist 	imageList� ��� Y   � ���Q���P� k   � ��� ��� r   � ���� c   � ���� n   � ���� 4   � ��O�
�O 
cobj� o   � ��N�N 0 i  � o   � ��M�M 0 thefiles theFiles� m   � ��L
�L 
alis� o      �K�K 0 thisitem thisItem� ��J� r   � ���� o   � ��I�I 0 thisitem thisItem� l     ��H�G� n      ���  ;   � �� o   � ��F�F 0 	imagelist 	imageList�H  �G  �J  �Q 0 i  � m   � ��E�E � n   � ���� m   � ��D
�D 
nmbr� n  � ���� 2  � ��C
�C 
cobj� o   � ��B�B 0 thefiles theFiles�P  � ��� l  � ��A�@�?�A  �@  �?  � ��>� o   � ��=�= 0 	imagelist 	imageList�>   � ��� l     �<�;�:�<  �;  �:  � ��� i   ��� I      �9��8�9 0 replacetext replaceText� ��� o      �7�7 0 sometext someText� ��� o      �6�6 0 olditem oldItem� ��5� o      �4�4 0 newitem newItem�5  �8  � k     a�� ��� l      �3���3  �]W
     replace all occurances of oldItem with newItem
          parameters -     someText [text]: the text containing the item(s) to change
                    oldItem [text, list of text]: the item to be replaced
                    newItem [text]: the item to replace with
          returns [text]:     the text with the item(s) replaced
       � ���� 
           r e p l a c e   a l l   o c c u r a n c e s   o f   o l d I t e m   w i t h   n e w I t e m 
                     p a r a m e t e r s   -           s o m e T e x t   [ t e x t ] :   t h e   t e x t   c o n t a i n i n g   t h e   i t e m ( s )   t o   c h a n g e 
                                         o l d I t e m   [ t e x t ,   l i s t   o f   t e x t ] :   t h e   i t e m   t o   b e   r e p l a c e d 
                                         n e w I t e m   [ t e x t ] :   t h e   i t e m   t o   r e p l a c e   w i t h 
                     r e t u r n s   [ t e x t ] :           t h e   t e x t   w i t h   t h e   i t e m ( s )   r e p l a c e d 
        � ��� r     ��� J     �� ��� n    ��� 1    �2
�2 
txdl� 1     �1
�1 
ascr� ��0� o    �/�/ 0 olditem oldItem�0  � J      �� ��� o      �.�. 0 temptid tempTID� ��-� n     ��� 1    �,
�, 
txdl� 1    �+
�+ 
ascr�-  � ��� Q    ^���� k    J�� ��� r    2��� J    !�� ��� n    ��� 2   �*
�* 
citm� o    �)�) 0 sometext someText� ��(� o    �'�' 0 newitem newItem�(  � J      �� ��� o      �&�& 0 itemlist itemList� ��%� n     ��� 1   . 0�$
�$ 
txdl� 1   - .�#
�# 
ascr�%  � ��"� r   3 J��� J   3 9�� ��� c   3 6��� o   3 4�!�! 0 itemlist itemList� m   4 5� 
�  
ctxt� ��� o   6 7�� 0 temptid tempTID�  � J      �� ��� o      �� 0 sometext someText� ��� n     ��� 1   F H�
� 
txdl� 1   E F�
� 
ascr�  �"  � R      ���
� .ascrerr ****      � ****� o      �� 0 errormessage errorMessage� ���
� 
errn� o      �� 0 errornumber errorNumber�  � l  R ^���� k   R ^�� � � r   R W o   R S�� 0 temptid tempTID n      1   T V�
� 
txdl 1   S T�
� 
ascr  � l  X ^ R   X ^�	

� .ascrerr ****      � ****	 o   \ ]�� 0 errormessage errorMessage
 ��
� 
errn o   Z [�� 0 errornumber errorNumber�     pass it on    �    p a s s   i t   o n�  �   oops   � � 
   o o p s�  l  _ _��
�	�  �
  �	   � L   _ a o   _ `�� 0 sometext someText�  �  l     ����  �  �    l     ��     Run the import script    � ,   R u n   t h e   i m p o r t   s c r i p t  i     I     ��
� .aevtoappnull  �   � **** o      � �  0 argv  �   k     J   Z     !"����! l    #����# =     $%$ o     ���� 0 argv  %  f    ��  ��  " r    &'& J    	(( )��) m    ** �++ B / U s e r s / d i e t e r s t o c k h a u s e n / T e m p / a a a��  ' o      ���� 0 argv  ��  ��    ,-, l   ��./��  . D > Read the directory from the input and define the session file   / �00 |   R e a d   t h e   d i r e c t o r y   f r o m   t h e   i n p u t   a n d   d e f i n e   t h e   s e s s i o n   f i l e- 121 r    343 n    565 4    ��7
�� 
cobj7 m    ���� 6 o    ���� 0 argv  4 o      ���� 0 
tempfolder 
tempFolder2 898 r    :;: b    <=< o    ���� 0 
tempfolder 
tempFolder= m    >> �??  / s e s s i o n . t x t; o      ���� 0 sessionfile sessionFile9 @A@ l   ��BC��  B . ( Scan the session file for an album name   C �DD P   S c a n   t h e   s e s s i o n   f i l e   f o r   a n   a l b u m   n a m eA EFE I   "��G��
�� .rdwropenshor       fileG o    ���� 0 sessionfile sessionFile��  F HIH r   # *JKJ l  # (L����L I  # (��M��
�� .rdwrread****        ****M o   # $���� 0 sessionfile sessionFile��  ��  ��  K o      ���� "0 sessioncontents sessionContentsI NON I  + 0��P��
�� .rdwrclosnull���     ****P o   + ,���� 0 sessionfile sessionFile��  O QRQ r   1 9STS I   1 7��U���� $0 extractalbumname extractAlbumNameU V��V o   2 3���� "0 sessioncontents sessionContents��  ��  T o      ���� 0 	albumname 	albumNameR WXW l  : :��������  ��  ��  X YZY I   : A��[���� 
0 import  [ \]\ o   ; <���� 0 
tempfolder 
tempFolder] ^��^ o   < =���� 0 	albumname 	albumName��  ��  Z _`_ I   B H��a���� &0 updatesessionfile updateSessionFilea b��b o   C D���� 0 sessionfile sessionFile��  ��  ` c��c l  I I��������  ��  ��  ��   d��d l     ��������  ��  ��  ��       ��efghijk��  e �������������� $0 extractalbumname extractAlbumName�� 
0 import  �� &0 updatesessionfile updateSessionFile�� 0 getimagelist getImageList�� 0 replacetext replaceText
�� .aevtoappnull  �   � ****f �� ����lm���� $0 extractalbumname extractAlbumName�� ��n�� n  ���� "0 sessioncontents sessionContents��  l �������������� "0 sessioncontents sessionContents�� 0 	albumname 	albumName�� 0 alllines allLines�� 0 aline aLine�� "0 equalsignoffset equalSignOffset�� 0 var  m  ���������� .�������� G V
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
ctxt�� j�E�O��-E�O [�[��l kh *���� 	E�O�j 6�[�\[Zk\Z�k2E�O��  �[�\[Z*���� 	k\Zi2E�Y hY h[OY��O�g �� g����op���� 
0 import  �� ��q�� q  ������ 0 sourcefolder sourceFolder�� 0 	albumname 	albumName��  o �������������� 0 sourcefolder sourceFolder�� 0 	albumname 	albumName�� 0 thepath thePath�� 0 	thefolder 	theFolder�� 0 	imagelist 	imageList�� 0 lralbum lrAlbump �������� ��� �����������������������
�� 
psxf
�� 
alis�� 0 getimagelist getImageList
�� 
capp
�� kfrmID  
�� 
skDU
�� .IPXSimponull���     ****
�� 
IPal
�� .coredoexnull���     ****
�� 
kocl
�� 
naME�� 
�� .corecrel****      � null
�� 
toAl
�� 
IPct
�� .sysodelanull��� ��� nmbr�� b*�/�&E�O�E�O*�k+ E�O)���0 D��  ��el Y ,*�/j 
 *���� E�Y hO��*a �/�e� Olj OPUh �� �����rs���� &0 updatesessionfile updateSessionFile�� ��t�� t  ���� 0 sessionfile sessionFile��  r ���� 0 sessionfile sessionFiles �������� �������
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****�� ��el O��jl O��l O�j i �� �����uv���� 0 getimagelist getImageList�� ��w�� w  �� 0 afolder aFolder��  u �~�}�|�{�z�y�~ 0 afolder aFolder�}  0 extensionslist extensionsList�| 0 thefiles theFiles�{ 0 	imagelist 	imageList�z 0 i  �y 0 thisitem thisItemv 1 � � � � � � �
"&*.26:>BFJNRVZ^bfjnrvz}�x�w�v��ux�t�s�r�q�x '�w �v <
�u 
filex  
�t 
nmxt
�s 
cobj
�r 
nmbr
�q 
alis�� �����������������a a a a a a a a a a a a a a a a a  a !a "a #a $a %a &a 'vE�Oa (a ) na * �a +-a ,[Z�\a -,@1E�UoOjvE�O (k�a .-a /,Ekh �a .�/a 0&E�O��6F[OY��O�j �p��o�nyz�m�p 0 replacetext replaceText�o �l{�l {  �k�j�i�k 0 sometext someText�j 0 olditem oldItem�i 0 newitem newItem�n  y �h�g�f�e�d�c�b�h 0 sometext someText�g 0 olditem oldItem�f 0 newitem newItem�e 0 temptid tempTID�d 0 itemlist itemList�c 0 errormessage errorMessage�b 0 errornumber errorNumberz �a�`�_�^�]�\|�[
�a 
ascr
�` 
txdl
�_ 
cobj
�^ 
citm
�] 
ctxt�\ 0 errormessage errorMessage| �Z�Y�X
�Z 
errn�Y 0 errornumber errorNumber�X  
�[ 
errn�m b��,�lvE[�k/E�Z[�l/��,FZO 4��-�lvE[�k/E�Z[�l/��,FZO��&�lvE[�k/E�Z[�l/��,FZW X  ���,FO)�l�O�k �W�V�U}~�T
�W .aevtoappnull  �   � ****�V 0 argv  �U  } �S�S 0 argv  ~ *�R�Q>�P�O�N�M�L�K�J�I�H
�R 
cobj�Q 0 
tempfolder 
tempFolder�P 0 sessionfile sessionFile
�O .rdwropenshor       file
�N .rdwrread****        ****�M "0 sessioncontents sessionContents
�L .rdwrclosnull���     ****�K $0 extractalbumname extractAlbumName�J 0 	albumname 	albumName�I 
0 import  �H &0 updatesessionfile updateSessionFile�T K�)  
�kvE�Y hO��k/E�O��%E�O�j O�j E�O�j O*�k+ 	E�O*��l+ O*�k+ OP ascr  ��ޭ