VERSION=6.4.9
# ${VERSION//./} removes all . from version, to match file format
curl -o "./spin${VERSION//./}.tar.gz" "http://spinroot.com/spin/Src/spin${VERSION//./}.tar.gz" \
&& cd /opt/ \
&& tar -zxvf spin*.tar.gz \
&& rm spin*.tar.gz \
&& cd Spin/Src* \
&& make \
