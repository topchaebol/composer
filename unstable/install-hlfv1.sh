ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start"

# removing instalation image
rm "${DIR}"/install-hlfv1.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �/CY �=M��Hv��dw���A'@�9����������IQ����4��*I�(RMR�Ԇ�9$��K~A.An{\9�Kr�=�C.9� �")�>[�a�=c=ÖT����{�^�WU,��͠bt{��=M5M���C����� � ��O:�Rӟ�C?��4CE�aP4��> �[�%�-[6x`��@�V㭫��� ��j�{�1� ,hTZ{�?&�=���mYաy��]�7�u+ծ�De�Q��7�I�맆���3L�� ǩ8���y�A}���ޅ�=F
R�P�gB!�̤���~ �'� �aC�k�`�:Tl�PE�h��@Kk�5SU�L�P�Q-�;�'�j9_��$V���d)���$0b�R@ �6:D-�����^���ѡ�Ul�t�Ȗх���VC	"���",v�v�ѷQ�0E-�f�hT��su�"�i�75�K��){$���C���`1��X*������W<)-i���;�X��Z�L��&-U�����8f�e�=Ī"�s	|s�������N{��2�yZ�A97%4�2��-��IOp�l����%bU�Y�1a�Ve�vSD�q����D�P=���Ee�c�K�	�f����C�1̎�b|��98�����ح̺�3�x�y��))X�� v�h$�o���chB_1�c����p����= �[�d	|�����P6놣s��p�ÐպW��J�3����,�DX��������_�5U'k��"����*i���nP�l���i@����]c Q!f_�U�yZĤ
:zO��	�H�?zRw��Y x��P�%<z]�����  ���.u䕡�2@ ���eDv�N ���o�,��5{y��˧�3�Pqf��<M�YI��rL�:d�.p;���K19�1-57J��l�.&�P\�/����e~=+���{m�bZ�\O1�u�4L��=��z~`Lz�6h#�K�Y<NJ}�{�Q���E���\�L��Gg���bN�`vq-�X�!�a}��~wa�]���n#�{�@_Gv	��!���~��Aق��J	��R�0��|�����P�p���!��2`b�����H����w��Wo�^V�I>rq&1�<���I=�fB����%��	�'��\���_-Y!�?��g���xy�|׉߇5�?E3�;��Y:��@�������0=�[F�T �UO�Rw?ꪉ�$�pdpV)��%�\x _}zN}#�\׋#ŭ�A��Ϥo����c(���&`k�6\���W�o������?lX�˦�6�u�����?a���	x��O<Ld����x���@ՑB4�=6�!n�:|@O�J�^�����6���;�w�7��*���7���Æ%��˷Dc��#������6��x{$	8���ç�����h&����y�V�ihhN&��)׼��i��׀�m�#ⶑ@5���U�r�X���&�7����:eg���S�oc�܍��x�:���pv(�+�B����喙��5� T�u�� ٲ�]L�;�������m���"�f��}��V��G�U�Y�S��o�ʕ�gՌ$����A[�;͂'Dʪ[Oa��>�zπ��L����_R��W�����_��/�������z&ۑ���JV�@ް��~�� ��+湻%h��d̓�t��$J�]�7�-20?,J`v>�Il������i���O��1��?����w=ܝF����׿w�'���4�=������)�N��(;��1l�������_"�����eh����*��Qݮ����g� \�M��n	��+����q�,MrO�u�f��	(������L^[�ϼ���Er�㞰�1E׵��l
���X$2�����v�g#�N��Nf_��G m��v��6\~�g�ީ�1>�[O���j�j��0=�F�t�
Q���u��m�n��q��Ҫז4�J�׵��l
�[�����o�6����M�xm
�X#ˆ]�}�u��~���G\󅙜:�����䥈�f��9��y��a��m�ٖ��"ϼ�G~=EAi��V�:3������g�މ�7��R-�P4(�?�hf7����?�������gb�v�o#�N����rG~۬�u׷l��`?�#�����6�k!�i�O|pZP��Ʉ�Xs"�o�'���ʕ�?�dS�V˿��?�o�!,���Zĝ�n�{��ޣǕp�R
e�(��\A�rR��I�_���@E�[�E���'���ӡi��};�u���_I��*��c�w ��rT���p��N���P�������!��C�W1��:%���T?L�v)�PE%lK�
-����'rs��_:�>�����~�I+8Yy���9�G�Xd;�o�_}B�&�>����|��������g��
[o�YV�Jم(.�a�^g��+L4܈�:�4d��6���8+Q6��w �;
4�?�{��������?����?�"��<�����{�󫏉����$�S�yJ����4U�q�����ψ�"�� ����A�?�@��`��<�~w�wv��+�s�,��?��ˏf�~��L?3_?q������|��1���Ǩ�G���pk�w~U~6)�ue���L��_�=\�� 1[��������_��W�������'�_�2�����,���v߄S_o����b����������_6�m����'�j�L��ꞧ�VH�c �:ǁ������M:�咆�|������b��e7M��>��>��Vn�����zD%!l�x�f1��o�Mr>P�.B=��:�������.7�l���r���2Pf�0�6�ц��]�5hYfja�w�����nT�D�Pf������{�Ξ��k�K�����)Y�H��lcLG��?ʺz�:Pk��HE&���4�/�� �Y�/m�q�p]�ʾr��	��F\J̋e.�b�TN<s�uX�7W�e*U1�%e�R٧B�����Hb5]H��!�5��-1�I�c;R�jBZ��'��i*�q%�~���Y�ҌƗ����	%�gu���ѳɦѓ�i�
�T�V�掣Ee�t3����9K���.���^�c�͠�Z�Or��m`|uڲ�ϖ��ѭmϽ�lŭ_+����7%�\E��>a��{ʖ��r�5f�b�o������t&��B&_����p�$ɖa��@6I���!PȚ���L���Np��He�)�͜q�4����%��m"�ZBvq	b	�5V!0�䒦cv�u~���^7i�f8x�˂��~�՚�˘�`��籐���AZD��R7|uFr�����BjB��B�v�9�RI�9b�\Pu� d����'���X=*�������p�:)ԶR媢�o��r<W�����
B:��D�_c)�7s��x��s�m��E:��8��%A��\��7d�4�R�JOk�-	��
�r��ٛ������F�]�[޹[5�����{P�[g(�rY���ꍄ�����b�'�����a��K&���rn��g�۞X�n#��*���n,� ������\����#,Co�7w����\B���S��V�������i�6����V���"��z3��wDcj�����'EGb3c�BC�b��;�g��7þ
o]�޽����}?�V�&���l��F�^��(�������l���Nx���[�l�����o��0���gcѭ��l��/?�:9��������h��,������@/�2y ��j&����R&#dۂ��SM���\3S��������H���'�F��Z\�o6�[�v�X*%�6�H%�!��I�TJ�΋Ã�*!B} 
��-1IK>:(]�wR�$����C)�$��tD��m�8߮]���x�[R�~�KV������Z��Ԫ�8���!�8�t�a����vf(��Q�z*���W�Mʤ�5$������I���RYrD�2��K�{���Q������ܺ���Փ�H�(�/Z�n��0��T�;i�q"���)�W��H�0�=���N-u�?avm)�qD�$Md���E���I����JJ����D?_�%;|��V�R�9���G�H�a`� ��"}D���Ǽ�(���E����n�z��B�BlT�wr�ATΫR�sM�i�*\)M��k�)��p�E�$I��+ŕ�H��9n��<��㜬s� P/m^(9�k*3�Y��4�D�b����/��l��_a�+w*�k8B�{d=��F`��pN��4k�y�Ț��I)E�u�8V��Rٔ��c�N#�8Q�]�֣(!�`��A�T�Q��E���Y�bw�N�
T�q�\ON�*Fw��Ģ5�oK}7p�?:��E)z�m6������>�6�������za�w��o6�����������Lx��G���&`]�_I��F���+��^%�8Z�N[�z7z��s�LR5?Ss���#$����-I8<���W���fU��[���Eiz_>��6w��)��!�S��tQ��h'L|��r��QS����z�jՎy�¶k5�#�8�$'�R�RUq��H�f�}�Ჶ[�L�ڼC�u��,cx�.��r$�g���<U�"�\SD���������ʆ#�ItM5�L��j��,�z�d��4��J?'�$+U�Fb�:n�[Yn�Dt�=$��Qu7�X\�!
y�h5�RE����y[���E�\?���X�|�͝b�+���J|���s�l�|SL�%�/�He��q��r	�� 	��fI�A��qZ���l�8x�o�.
�zcx�Z�,��=#��r&����էf>�%�$���ϝ'L�8g;������vx��VU��_�ͅ3V��h�0⢐�PM4��Y��ZTA�5�s�4�0Q7�I��9���ҏe��>��?{_�����F`3�"o���	���Î���g�Ȣ�����Y�?��p�֬�
������S�����?n���|��嬗�;��Ys!�/Ĳ�Ž��q2J�PS:^�=ɶ�6ά;N�-:n�]mΖ�?{gҤ6�m�~ŝ�P���A !@���z�h������\i_��p�/�d��u�:{�uJ��R����8Z����n������j��s/�A1��cv��v�q�d��-ӻ���pf�*�x��qDl���)|0�.6����[V��yu˱M��^)��8���=2P���2�疾�OE1T�\�1X몡����`M����?�I�6CC��_��g?5��*�x�"2$��P\i4<�Hf�+e���t�d#c�G;�=�|?�ÝC+㍱@��c�{��~XQWQ#ă>U��n̹W���dG��5�+	��]l-�F�Q���?4�M�x�ݟNх��?����@��?���_����L�?��k�w��C�h�O~C��k����$Z�e�$1��>�
�t�$!�'�x׿��U=�)�Pŉۮ��8��kj�����"o�`�)�������M��泾���D>�v�o�l��������ٿ��Cg��ܨ��H&����L�+I��e0�nƪ��_�O��mVV��W׌�_���L�҈'c_���m"��Y�)pa��х��`��������������������O���?�?M��'�'�
��	������n��x@�A�[��I��6B����n��:o�}���������Գ��4BW�?KR!��,&x�bȔIi�c�,f2��8��N(�'�<"<fcNb�f�4"R�?��������S,�Z���5�7���5��KW¯�?u�
E�^�MT�:z�M�����nջ�v"7[��}yi2~0��y'Nַɝ�jTIM$�̵�����S|��JL��]dU�vK�"Đo�Nh(�����[�6��I5_��:��=͍\G�[��������c]��lc�zQm����?IP������C0|�ta�������h���?÷AS�������	 ���!���!���?�o������?����o#tF��? �����g_�����7�?�����g����1�+m"^Jm��ˣ�QT�ֿi�G���?rCĿnQ��ʖ�����g^%/J���8/����1���X�7b!·:�I��k1�eAݤ�nE�7��Bzk���2��_��!��<�V�2,��k��M��`'#�kƇ,���6���6���Qž�y]��F��t�{}
V�ʡ	a�7�+�W��}wX�.\ϯ�r�����)sV?�]YFQ���(���JQ)��n�uU����X@��ZJz�n&=^�o����[�M�e�_�F�%#G�l'�?�k���?�o�������p��-:����[���Y�'�O� ����	�����j�;����7����I4������9��M����{4��I�QN1lLFQ�p�E�QLβy�d9�r9EdL���4��\`#�泈d#8��ntA����&`��~��on�b���/^U q���%�c6��H�*n|�G�[/޺����6}N{���Ӌ�UWk�F��uo^��i�?,�c9K�Xh���va��Ca��s.���逆�\�27��J�������.�����o�����v�;KS�����$��M ���������?@��>����?t�&>����g(��o�.�?���M���;�*������o]�����hY�������o[�������gt�s���/�T�>� ����x�a�<&��yJ�H��i:�y��i���(F�~�.�����?�W����T�ʥf��d���]6� ��bm���|�+v��l�/���X�t(�*<rk:��6�z�rq��Z�j���r�Q��^Ii���{���8e��K5����%�Ӆ1�qM�6���P0��V����������?�L����	����?��4Bw��D۠)����O���0�	�0�	�p��-�p�Cˀ����_'��Z�3����xg�������B�c#����|�Ȥ�L����H?���������}/���r�~������'�zY{�B�6v��)u���®hI-C,�'Z9Gl�k�P���p��dj�_��'\5R�ˣy���\�j����?���8�	��Wي��?nI�gp�fVΏ�:�?�p�q:
��⊂�NR���:C�Ø����7����p�ï��?���-�p�Cˀ����_'��h���?�������{@�������?�@����zzB�G� ����N�?��F���-��߶�C�G{tE��$S�#�,K㘤���"V���'(6IX�ĩ4gcA �ds�'H*O�$&R2 �����C�G{������#���>]b�]1>��fl�i��	"�GV��}��0�4�}S!��������*�/��v1��1^2J�bd�}j%�X�����P9�,���Ĳ��#���j�<G�
�?�J���h�����h�.����ڣ�������6������0��?0��?���_������]�uB�!��5:����M�w���f���ρ�o���z���P��s����m���3��/|q��{1�ߌ�/��ᛱ��8?��^?��A�_'w���j��6q����n������18^1鎴�;
��֞cXF�|~Y#���пV�p�7�a�� }��P�	'�����"�L���\������,�sq�U�_ރ�:�xt�u���N�`U+u8ľ�H��c���0'�Y E>O�x�'�8]�y]�P�/tU��`��=/���GK�AԷn .뤿s,�ރ��=��[Q�}���a��j����di�������ϰ�=��Y��c��a�5�4>�sUd���O\4P��{��=�@���P�^��R��z�C�nI^&�q�'2�]�ʀ���e���0]�m�a��=�mvl*a_v�d�F��FE����~�CSŷ�2�R�Suu= 8{��r�\�>�p\Ɍ���9���E�N�T��µ\�v��|��ʗ�E��\����7Ӊ��?Z����?Z��Ǯ�:��������-�������?�����q�����_"~���p��&�B�O������7�����+���,M|�?��C��7B'��}5���$�4��p̯��������$�$���q���@�~hJ�x��_�G��PY�����q>/h�R�[��[�e���C������_|O�"��|"�b�����Lw>���^�1��\6�=�.)�}ٵ���ާ�E�����}�Z��F�~;]��{��Y+{��vKj�"�V�Z7?�zPʞj�$�^��>���b�y�i�WaJ�S�ӑ��>8U5�oD�3�G�H�̛dA6Y_���:;ۘ�C[Sp���8�'�25��.��o�������h���c~]��Ǯ����p��=��0�ݢ���������u���ߔ����Ȝ�"�a'��N�s���-������?lc`�z�����@�1����voq���܋�͌;9Y���Ie:7���\8�}^���^E�Y�hל��6��;�M�|���&��D�����<\��=�SuM�yI8�yk�k>���	%į���H��`��Ml���{����O�t��e�����p��q;=�"+Q�*����l�z�"�e����A�j�4�_m���%�]��^�����Fh���c~]��Ǯ����p��=��p�]������������o��C�C[����x�Wi����O�����O�O�?���M���w���� ���ߺ�O�A�C#���������Q��o[�)����p�����<�pD�R�34�	�r��S88%���T��|�d#�%��ds��sN`�s|���ߛ.�?����?����y�Q��+����:D�"~��$�x=z��Y������"<��JZ`�@��v8���+�M��@�i�ma����N�9���p�z����ro2߫�aG�3���٥�;��q0��|'�k d�k�`o����9����(F��ٝy���~�;F���^�?��&hy��`�������=:�����Ew���ڠ)����'������O���O���_�C����]�uB����C��:��� ���t�������������q�c�s��r
�=�ɗ�^LhA:����������[~�z�D���ľ{�sP��	�aNM��j_�Ɍ&6�]�C�l���M�E��0)b6%.r��O{_�����j�X-�Gxe���]��X|=�}s�s��������y��ۣ�ƷG;Q��!U��jseH:zy?&�ٯ.#,�x"��(p��f�bXV9��A��r��y�a�b����J/����Ȕ��L�|��3im�}��C]�1��Ws��;����L�Q��YFS.�{�^_]F4q��1���k.X=B��#�"�|�m�v��N����-��2��?v��	����[tD����D����'������O���O��?�����#����D��K������]����G#�O�t�0x�	q.d\���9#�DĤ4G2���]Iw�Z���~E�Y�C}3��:D#	$����R��~}A�$�J�X�+>{��Ċc{߽�9w���#��#��Y��"&b���4f���a@����&`��������i�;'v_�Y^��ԽБG�mᒭ.���P�f�)y��m��JT��k��M�4r3���z��8lBm��2&�x�CU9l&�ߔ�g���/����=�iV���(��0w���V�p������������Ȣ��������@���P���?� ��1�����袎��w����(�?�hu���t8��?����C����?�����*��O�q&i�
!�$L�3#��PMEt�q���I��t¥��|#B��������O����.�p��W�#��bݓ�N����&=_!L�X,��z����Ϙ2O��?KK���c��I�+�˵�%���Ck���l�c{�o��@0B��wC�p�mJ�Dײ��p����
����>�a�C�@�����������O-@��aH�	�����d8�u �?a��?a��?��k@�������s�?$��2��
����G�_`�#�������?��k@�������s�?$��?4D�|C@��C��9@�������?����H�7��J@�r ��������a��������4�C�Gs@���D`C�	�( (6%�4ey2���R&�I!�<�8�	!p: �0ao[�*% �����C�Gs����x#�3a%���l+bmƘ�Nyz�I�Yw�C>j{e�����<��;�DF�B�$��sP}߉�T��Xs2�&<%n�ɒ�{��%�/:{{����谊�Z���Q:<	s��x+P8�!��94|�C�G�@��������h��?� 5������?0��?0��������0��n���C�Gc@��? E�
��f���/���2���c��>����ΐ�Kt��akc����[�nD�gc�/�?��[�q4}3OC�zji���4uuۓ�]l4�	nF^vV���I0$��<�<X{����cn������� ���\ߣm��ɞ7O�z�.GSϸ��s�����jd��K9��:��dK\�&6��_y���Mr>�3Z���87s�4*���a��篱�o��?C���?��ϭ�����h��?��������s��?�����y�����7�8ٿ>^����8GQ����G���>~��4����_�U�m�����$��u �u���B?�p�] ��7��0��j���h(�"������_���'����Z��oW�e1~W�u���8+��e<�����뿳�O�;��|����a)۪��y�J���J���|���G��ߙ��~�3�M��_g�:_w>�����S��̮\H����Lڜ��J}%qG2�a����aS��4se��/[X<�/���]�U�����w�wv8��ϥ�A9��Q����������e\��2����q����^e�<{�݁��]�tX�/��p92Y2յbX�~o���e2�>Y��ɞ?g���D<Ւ{j�c�&������+�j�u�l>��J�ݛ�]�~y��ŅȎ�6��ۭ�E����.�cnj鞦�j﬷�ޒ7�g��z��U��������.y����[����$� ������`�Q�������������ǻo��';�i����Qw��s����ڟ���|h��?��Y��!���z�'ռ�8Ƥ,z�m�I��I���*��);�����o�<Y����&��ɓ������1ܧv<�zm;+��1��	���0w��&^1�j�����;�ڐE5���g�o�ϣZ7[��f}����^���z��(^_�ʗ$k�+�R�/όo�]�$N*�VY���/E�V{���;jY�R���G��Nxj?���9��)�;�/Ej-06�_�}��3zv���q��.p�����?v��8�MC�6��R�mnCa�RZ����L���;������[��>`6;򒶲�g�����go����_����.y����[������ou���%�ò�2@�@���̃�?	�����K���ۃg�_]���zQmC�mlU�"�]Fŗ�W�?���λ2�Ee�j���8���r�j�_��W.�+l������[�;�I�5y:w�����]�l�˙#�"jۖ{�7�dj�YѺ���Q���>Ŋ����z�H�>��A�f��d�=��*�n.}��_�Mz���<�,Z�s���%�W;��4�r�h��Rl`k���^���� �)_?�ó/�p�[C<u"��{ZT�鉲�KG.�������0)y����fL��ʘ���PE�|I�f��R'�OH��P[p�de���K�$�3�(��b���]��@B������u�?������������4�����g-hJ�A����p�A���W~U���[�o���_'�N�T�~�t�l�_b�"�UE���}/�0E<<E+{�^����y�~`�g�t%y�R�a��3r~<��vW>9��8O��C�bE��Zy�`7�T��g��䦝���Fǝ^\�w�W�ݠ8>�����o��n����d�:��Ï���/Ƽ�-y5���O[�h���1���^�c�dz��M�]f�t���!}ƷT�lgf����� \%f�m�C��}e *�����3��,��h5�	�D(���̀�����9ʫ���z�uh�Zf�n�+v�*����O�-��w����%���7�`}�P4��V�����+w���H�*;��U�9���(�~VW�tN�♤Sb����Y�q��rT�Ñ���Ց�)/�'��n�2����t�t�qz�-Jv��a����=v���DE��z�{^�e��S����u+) �E�җlA�z��V���W垜���]M�`/s|('aY�U�PX��h8ݕ6;I�x�o�H�?��k��?(6���5���{W��'�o���S%j�Q��ڋ�X#E	0���C�.Ã,��(�7�S�_O�m��$j�v�����*3��qIu�����FX���~�r�l��ֺ-a�rМ�_Ӊپ���z��g���?�ڝ3u�SQ!��Ny�f[yNә�u���~Q2_��������X�����ʔr#4uO�xˮc�d���P��l@B�A��14z��_�@A�A��9���������4���  ��>��y �E����}��� �� ������ׁ����7?��m�� ��7��$� ����������f��A������������Z��'|@�qD)��D,�˳)!���Çl��M�<#,)iDP,'d�����������X��I������Fv���T�k�O늙*���$ix�z�����ޝ��U}J1�?k��G��-�ur(ҮVr���x��G簛.���5���&�)<K73i�#,��Z�N��w�^�3ӣy�E�~�ՏB�]+3yN�}{�-fv���0��ug�>�������$�1p�ׁF�X�8P8���5$���������
��b�fP��o����9�u�W������H�?�����]���q�����	����o���������B�������/��ւ_����������KFi���Y��KעI+����q�_U���d�g��^}
��R+���E�E���]���W�me�J��8����t����벚5f=:��D���R"�>�[����v���b���mEZ�x.O|�R�^�xI�.;sahb�d_bLF�ۘ�x�H�e��v��}�2�-���[��T]�$V�g�Ȇ(V���$[Uo#~Y�e���V<`�(e����v+傛����eZ��;��mf�˻[�P>�Qϝ�P�[%�G̾������+�KO��4�5�����n�f���������Ш���������H�?���?���H�?��ƀ�������.��G���?��Ǐ��(h����?Ő,��:���'�����Ԅ~�A�#�:^����������x��������I?���O����?�p���X��(�<��XHɈ�0dٔ�I�棄����;!J ��Q��{_��U��������0��I�Vχ�q�����aW
��O_6q���^m�Lgy|����|�n��w���(��ģ��?j�G�����w�Q�����?���?B����sw�O��Q����t8�?���O��A�ׂ����� �?���O���4���?I���c�x6%)�e�����wE��A&q�qi"�QD2Wj�����*��п
��(�����Z�'�?�E�s�	~�$��D��l��o!:��ro�u�q�Bq�N���"	���+�2֍���:��,j9��kL&)vѣ�@���e�W,1Iݶ>Z���rE(�`1[nO�LK�q�,��Ι	��������`�KMh����w4�����9 ��ԃ�O����?�iu��{�30�W������p��Y����_MhJ�A�; �����O=��B�{-h��a�[�@��?��v}���o��������W@B�������ZД���w4 ��s�?$��|����g-h����7$�?�����������7���f���ɒuR.����M���s�'�x�����k�q$;���f����f(��4"T��̲=ݶ��&�r���KU����u�ˮ����Ѡ}�/� R���$ ���-�DHB��w�x@�S8�[��=��陞Q�g4m���T�����?�_,��o��7��g}�+��������_�����w���{������n]�V��2�q����Ýn�����?~������5G���+�"~�p8ДI	B3 �b������y)��f�`�`8"�1��l�"р�0�_7�=�2���׏�����仿e�����ǿ������ȏ8���O��w�kq�f���5��m�o�[�T�8)@��6��+P5��l���~�-���7�B~�&�o�����p�uqP
��`QϚl�-'e����w���'��I�-p�J�ƍ	�_�zJ�!��B��a�L�i.=�;e���u�y�e^��1~��Ij���'G��r�'�l	K�|�1��Y�*M�f]��2��4�׫�_�w��A¬r�.���4Z��%��8��ц��<��A�4KI&Rq����V1i�	�5li)���Ǵ�,�Ɣf�ځvcAٯuF^'Z�bI���!(���-gi6�5y���9B?�pN��1�9�LQ�D��;���U:���t�;�`����~~ܳ*�\���rc0)DEy�S�p6�k�{��+|gj������4N	\�p+����X�B�|�P�RC�ǲ��d&��m�!;#J��q�?R�V���Z8���R��ևr( D�H��)���-] ��'/]"UDӕ*&;��!,�o�� jB14�1�p��U�Ny_�0�� �v��5��0�:����7WK\O��F�2�\�"7�lF&o\����\�	�ɸ/W�����c͆��ޑ��"�~�DʕD��D��E�޾H�Y*�u1��W�_�w*b�.N�M�x�e�8^�]�i[��S�Di�/1~�Q��t/�d����^��.�/u���u�S�so8q��p�*��x?��M��X���~�������6kJ��K&"�pR㣊r9�l�d��I��@�-Ot�f>W�U5Ŗp�C�#Q�l\�M=}f���l��d0v�<'Z�F=�	V� �q�w/S�LZ��<�j�����
яO��_�d��֊z[��\���E=�̖�XZ3{5f�K*]�kj6ISբ�4M�K����fY#>E�HfIYA��F&<I�큔��*o��v4����)�R9�n��)��'r�������	+[H*Y+5*ê\���|{$�fo]�,�O.��l�ݷ&x]JWJ�Ԡ�g��^#T��퐯=Y[1!й8�t.΁� �K�]Ňm���&�q��`uK3�gM}؍���0z�9�`� ��s��~�m&�D��դ<��T�:�CLJ$r�R��T%�,"��k�2�z.�'5��۝r�4
�$�Ca!��i�0�s�~��U�1��
6�W�^�/�a�ةa��d��Ey�*(}�B|�-��\��b����/��[M��5�T�JI�.*���E�٤��Gخ%�zM�狧��L�h���L�QŬou���N����1HN|��a!� /�)C^v���{/O����^�Z��|�/#����6���??��אW���̿!w�_��_X��������Nn�H���M>X��?ߘ�a�~��7���;S�?�E������I���;3YS��@*õ%n8 ZU� l��C,7���7Q��=oʻ���~�h$%�:W#|���:�
[�~;�l4*MR+FN��zռ����"c�
X��پ2,Y����L�\*�[}ӸL����J����M(�D������$�UL䪘T��L����*��HN�d;�5�*�)��S���f�<�A}R�-C��E�"��R��^����o�~+ݒ:x�۪U1\����+&Eڌ"u�@��lr�_˄���-=a��;��H��H��H5���L �v�A���bǏ���D(��h��w�`+G�d
�_�Tn4��~�>�s@�I2Y�zxd��H�K���KN
q��r��("��|���`�iB,��W�}ͫ�XF�~�1Ef\����D��$��H�E`3��GC,1�*A�5�bа�4?�J4z5�4���ߊ�J?����(*y�&��c�E�`��b3�����A��ה&�a[����U!{��΁�=/x3��u]R�4u�U��[��;/";���W\b������ �?�G~�> �.0���{?�3C���A���;�ʿs���>m�O[�ӹ��o_j/\|f��%��
�9(�F-��hrE[uU �;�UЮbd��ذX��Ft���>�mz�t�������7�	"դ�i2��PuJZ՟�5�a�3¨"'zС�D�6�����&�
��z`D	Y�#��M�m[14w�n2'>��}�yn7)ŵZ�dn<2��~���%�j�T:\e�m��J���Q�u���c�.���ۙ�eY���R,�ZE�[�:u2��^�~!�l��~���sl�[?ǧ�ϱ�V=�%xk���Vm��[�����o\�o�^�Q��Ψ�G�2'V���/�X�@^_��VZ�?7��-M��YZ4	��ܢ�H�c)�4"�Y�}	��J�ݷ��)!����K��Kx����*	yym��������#t�2�Oi8E������
��iK[��s2`o#�;/���y�*�b|�4���p���I�����.i> �'��p+���SC�#������ᶢ�p�e@��� �������/L�M�?��:V_p��t�v~
���Qpk>?�(Z�mK6��ޙ���D�E|!��~9;�3�����?�xŰ�+�b����@z�?��3��ߞ�|C�1�?��01��$6�X���5C|�B8���n�b�O��r0��� M��I���|�]ߦ����_������O?���o��~Z�	�D._���ϙ<�`�,��,ݻ��r��z˞�������y�����7���[��Y�}�������-��DZ�����v � ��r�U�#��@,W��]`�\?��rlG�}uǸjA���x~`��g�j��L+7�$!���*:��wA(XU��Xk�Y�ꉌ���}a0�L./��4�3�.vC9:���P�(�y����3 ���IzL�/J�}OS�M�q��c��^N��al���Hz��yM�y�3���lSa�<4�X�*ٞ#���w=�,+�253C"X*�\�$�a%��z����}᳢��"��8cHr]�BY^�g�b�}�[���o�RdE���x������i8֯6x|�Ղ`/��p�_7r�X�n��~���c�����u�������t	랇>�uj��N��� )>���!@:�ۛ����?Y������ǂ���o$��%oSѽM�n�.J�5tTV,�A%�2��(ܫ�ʫ*
�@��E�ؒ�HX%i�M�iK�з,����X����i���QAD�X�*��gS��B��S���Ѓ���}5�"���������p�w�/ԥ�;���q߂5?X!o��AW���,��s��P�A�gN���*�j��_ƴ��N�WY�к���y�z@0ݶ�^=��+���v�=��G��I7�y7N�����̠_�2J�m8B'%�������q�&T�Pϔ�sw�9w�Ce�p���ӷT
i[�)y��!�j۰��߃>��~u~������;��^'蹋�UO�~�� ���e�I;����۔��z}�𕙜�M[tkYE����B���?ݧq�� U���ks�Da��K��?�eP�N�n�R�����Q�$��y�C �HB�@=)8S�*�-�A�5x�?h��Ѧ$�snQٰ�L�Z+1]�с����y� y����0|�7uo����P�w����g���i���nθhC�_���?���G�����t]��PX~9||U@4��ܦ�������Kǚ��<�5�]%m.��1�U���\&�_dM�!l+�7����?9��P�
l�{�:.7���>���:|k��w���)Op�$T���t8oj���'��qI��G�h�~8x�;��ע�{��+]L9k��y�˿#�;jOA�Cg�?���M��U��E�vߙ�����Lr�N����r�c�mG�PW��Z7�E�F�Z�Z�Q���*�:,b$�(�l5�F���?��E��۸��E`nV�7�����Ug^�!�މ��������`l�c�����ph]�#��?[��I��&�tk tnG�!�	$3˱��f��k͙�t����
q��� ��2t�x����4E�2���8~���<N�(�c������f�&���ڥ���������VsSН�|��u�HQ�}�$�e�2W )��s�殒Uh��XH�{}]y��oy��>��C~�V���t>y?GU��=�"��37N������.f��)8xE�a�Vfԝ�s���Q��M�Y*^f�\��$>��)�r�7�}�KkT�'Cq��a��X��7��V����S��d@���[�$����"D(�;�C�k��:�M��y��Zh�`�����c�.���������7��{��� >�ǦZ�˅h�|���J��ʁ��{���4���6 $P&c�d׎�$U��JY*$��	�s�4V��J��TBbC u`�/`Al+�_�C;21�0!�{g�v�4i����%����ǽ�{߽O�KǵE>\���w�?�{��P������D�"|bĻ�_�6	T�i�]���*=�0��Ìί������`nfv~NY����z�?�W���5Sˣ���I�͛6�3�������i�s�����^������������|����ŉ�)Z/�x�����ͯ����P�����BW�p)A�8�! 7����|�N��y�M}�{
}$�{�d*��Nu�[��Bh!��ĉ�%�}����-�1h�'RG��?�L��a}AUc{���� \U��:��qK����EIUT%�!�]���H]f�aor5)j�s�t$�rV%u=��&y��o��9� �9�_�9%��j�+^�WW��2�Z]�w4�s��٠���u�fǜ2�g���M7���4�`���i��B������|XĒ���E�㱧�ʖ�W,%�����U�V(�rA�c�x��L8)��U��l�H�Y�$-5\6��ᇻR%h����r|.��g;���+ו���`����E�b(jK{�a�T[I�n��Ͼ�����J}�o������^������U���j8�7�wFXwuq4��8��4]Ǣ&1qO+Pb�e�4	5T2E�Yݢ%�6�y+��lN/�5C�I�"%�L�RN%���Y�
��� k��o�w��6����n��q��|dz?��&�үR�R�p'}i��]X���2	�a(!3%eX�2!�zM
�f�/�[O�1:�r���L�d�J{�1V%)oKRe��c�m��&��r=/X���c[������w�/��Km�����+=����A��t�������!�|lt��H�9a�FNG�P����FRn�E@]�E�ou0�;fpG�g�F�g�F�gT�AE�F�g�F�g�F�g�F�g�F�g��8�90΁q�5΁�U��q���Va�������Ϩ���Ϩ���Ϩ��@ �@ D ��ϗ � 