# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit versionator java-pkg-2

DESCRIPTION="These command-line tools serve as the client interface to the Amazon EC2 web service"
HOMEPAGE="http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351&categoryID=88"
SRC_URI="http://s3.amazonaws.com/ec2-downloads/${PN}-${PV}.zip"

LICENSE="Amazon"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

CDEPEND="
	dev-java/bcprov:1.45
	dev-java/commons-cli:1
	dev-java/commons-codec:0
	dev-java/commons-discovery:0
	dev-java/commons-httpclient:3
	dev-java/commons-logging:0
	dev-java/jaxb:2
	dev-java/jax-ws:2
	dev-java/jsr173:0
	dev-java/jdom:1.0
	dev-java/log4j:0
	dev-java/wsdl4j:0
	dev-java/xalan:0
	dev-java/xalan-serializer:0
	dev-java/xerces:2"

DEPEND="${CDEPEND}
	app-arch/unzip:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

S=${WORKDIR}/${PN}-${PV}

java_prepare() {
	rm lib/{bcprov-jdk*,commons-cli-*,commons-codec-*,commons-discovery,commons-httpclient-*,commons-logging-adapters-*,commons-logging-api-*,jaxb-api,jaxb-impl,jaxws-api,jdom,log4j-*,stax2-api-*,wsdl4j,xalan,xercesImpl}.jar \
		|| die "Failed to remove bundled jar files that are provided by system."

	find . -name '*.cmd' -delete || die "Failed to remove non-Linux files."

	sed -i "s:LIBDIR=\".*\":LIBDIR=\"/usr/share/${PN}/lib\":g" bin/ec2-cmd || die "Failed to set the library path in the wrapper."

	for FILE in bin/* ; do
		sed -i 's:${EC2_HOME}:/usr:g' ${FILE} || die "Failed to set the EC2_HOME value in the wrappers."
		sed -i '/PREFIX__EC2_HOME/d' ${FILE} || die "Failed to remove remaining redundant PREFIX__EC2_HOME lines from wrappers."
	done
}

src_install() {
	dobin bin/*

	local libs="/usr/share/${PN}/lib"
	insinto ${libs}
	doins lib/*.jar
	dosym $(java-pkg_getjar bcprov{-1.45,.jar}) ${libs}/bcprov-jdk15-145.jar
	dosym $(java-pkg_getjar commons-cli{-1,.jar}) ${libs}/commons-cli-1.1.jar
	dosym $(java-pkg_getjar commons-codec{,.jar}) ${libs}/commons-codec-1.4.jar
	dosym $(java-pkg_getjar commons-discovery{,.jar}) ${libs}/commons-discovery.jar
	dosym $(java-pkg_getjar commons-httpclient{-3,.jar}) ${libs}/commons-httpclient-3.1.jar
	dosym $(java-pkg_getjar commons-logging{,-adapters.jar}) ${libs}/commons-logging-adapters-1.1.1.jar
	dosym $(java-pkg_getjar commons-logging{,-api.jar}) ${libs}/commons-logging-api-1.1.1.jar
	dosym $(java-pkg_getjar jaxb{-2,-api.jar}) ${libs}/jaxb-api.jar
	dosym $(java-pkg_getjar jaxb{-2,-impl.jar}) ${libs}/jaxb-impl.jar
	dosym $(java-pkg_getjar jax-ws{-2,.jar}) ${libs}/jaxws-api.jar
	dosym $(java-pkg_getjar jdom{-1.0,.jar}) ${libs}/jdom.jar
	dosym $(java-pkg_getjar log4j{,.jar}) ${libs}/log4j-1.2.14.jar
	dosym $(java-pkg_getjar jsr173{,.jar}) ${libs}/stax2-api-3.0.1.jar
	dosym $(java-pkg_getjar wsdl4j{,.jar}) ${libs}/wsdl4j.jar
	dosym $(java-pkg_getjar xalan{,.jar}) ${libs}/xalan.jar
	dosym $(java-pkg_getjar xerces{-2,Impl.jar}) ${libs}/xercesImpl.jar

	dodoc THIRDPARTYLICENSE.TXT
}

pkg_postinst() {
	elog ""
	elog "You need to put the following in your ~/.bashrc replacing the"
	elog "values with the full paths to your key and certificate."
	elog ""
	elog "  export EC2_PRIVATE_KEY=/path/to/pk-HKZYKTAIG2ECMXYIBH3HXV4ZBZQ55CLO.pem"
	elog "  export EC2_CERT=/path/to/cert-HKZYKTAIG2ECMXYIBH3HXV4ZBZQ55CLO.pem"
}
