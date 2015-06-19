# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/webcdwriter/webcdwriter-2.8.2-r2.ebuild,v 1.1 2011/09/09 23:19:01 caster Exp $

inherit eutils java-pkg-2 pam

MY_P=${P/cd/CD}

DESCRIPTION="Make CD-writer(s) available to all users in your network"
HOMEPAGE="http://joerghaeger.de/webCDwriter/index.html"
SRC_URI="http://joerghaeger.de/webCDwriter/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pam mp3 sox vorbis"

DEPEND=">=virtual/jdk-1.4
	dev-java/jnlp-api"
RDEPEND=">=virtual/jre-1.4
	app-cdr/cdrdao
	virtual/cdrtools
	mp3? ( media-sound/mpg123 )
	sox? ( media-sound/sox )
	vorbis? ( media-sound/vorbis-tools )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	rm -v "${S}"/MD5Verify/*.jar "${S}"/webCDcreator/4plugin/*.jar || die
}

src_compile() {
	epatch "${FILESDIR}/configure.patch" "${FILESDIR}"/${PV}-javac-flags.patch

	local myconf

	local java_conf="$(java-pkg_javac-args) -classpath $(java-pkg_getjar --build-only jnlp-api jnlp-api.jar)"
	java_conf="${java_conf} -encoding ISO-8859-1"
	use pam || myconf="--pam"
	myconf="${myconf} --user=root --group=root"
	./configure ${myconf} --javac-flags="${java_conf}" || die "configure failed"
	make || die "make failed"
}

src_install() {
	newinitd "${FILESDIR}/${PN}.rc" CDWserver

	diropts -m700
	dodir /etc/CDWserver
	keepdir /var/CDWserver/bin
	dodir /var/CDWserver/export/Server/tools
	dodir /var/CDWserver/http/rcdrecord
	keepdir /var/CDWserver/projects
	keepdir /var/log/CDWserver
	keepdir /var/spool/CDWserver

	insinto /etc/CDWserver

	PORT="12411"
	if use mp3
	then
		MP3="on"
	else
		MP3="off"
	fi
	if use vorbis
	then
		OGG="on"
	else
		OGG="off"
	fi
	if use sox
	then
		AUDIO="on"
	else
		AUDIO="off"
	fi

	cd "${S}"/CDWserver/config
	cat config.default \
		| sed s*#portNo=12411*portNo=${PORT}*g \
		| sed s*#MP3decoding=on*MP3decoding=${MP3}*g \
		| sed s*"# ogg123"*oggDecoding=${OGG}*g \
		| sed s*#audioCDSupport=on*audioCDSupport=${AUDIO}*g \
		> config
	for name in `find -name '[!M]*' -type f`
	do
		doins ${name}
	done

	cd "${S}"/CDWserver/http
	for dirname in `find -type d`
	do
		cd "${S}"/CDWserver/http/${dirname}
		dodir /var/CDWserver/http/${dirname}
		insinto /var/CDWserver/http/${dirname}
		for name in `find -name '[!M]*' -type f`
		do
			doins ${name}
		done
	done

	cd "${S}"/CDWserver/test
	make || die "make -C CDWserver/test failed"
	for name in `find -type f -perm -111`
	do
		dobin ${name}
	done

	insinto /var/CDWserver/http/rcdrecord

	cd "${S}"/rcdrecord
	for name in `find -name '*.html'`
	do
		doins ${name}
	done

	cd "${S}"/webCDcreator
	cp start.html index.html
	for dirname in `find -type d`
	do
		cd "${S}"/webCDcreator/${dirname}
		dodir /var/CDWserver/http/webCDcreator/${dirname}
		insinto /var/CDWserver/http/webCDcreator/${dirname}
		for name in `find -type f`
		do
			if test "${name}" != Makefile
			then
				doins ${name}
			fi
		done
	done

	cd "${S}"/tools
	make || die "make -C tools failed"
	mv CDWconfig.sh.tmp "${S}"/CDWserver/CDWconfig.sh

	cd "${S}"

	dosbin "${S}"/CDWserver/CDWconfig.sh
	dosbin "${S}"/CDWserver/CDWserver
	dobin "${S}"/CDWserver/CDWrootGate
	dobin "${S}"/CDWserver/CDWverify
#	dobin "${S}"/CDWserver/setScheduler
	dobin "${S}"/rcdrecord/rcdrecord

	dosym /usr/sbin/CDWserver /usr/sbin/CDWpasswd
	dosym /usr/sbin/CDWserver /usr/sbin/CDWuseradd
	dosym /usr/bin/rcdrecord /usr/bin/files2cd
	dosym /usr/bin/rcdrecord /usr/bin/image2cd

	# back to defaults from -m700
	diropts -m755
	java-pkg_regjar "${D}"/var/CDWserver/http/webCDcreator/*.jar

	java-pkg_jarinto /var/CDWserver/export/Server/tools
	java-pkg_dojar "${S}/MD5Verify/MD5Verify.jar"

	dodoc ChangeLog README CREDITS || die
	dohtml *.html || die

	use pam && pamd_mimic system-auth cdwserver auth account password session
}

pkg_postinst() {
	# ripped from the makefile
	local PORTEXT
	if [ "${PORT}" == "80" ]
	then
		PORTEXT=""
	else
		PORTEXT=":${PORT}"
	fi
	elog "To do:"
	elog "1. Enter \"/etc/init.d/CDWserver start\" to start your webCDwriter"
	elog "2. Open your web browser and try"
	elog "   \"http://127.0.0.1${PORTEXT}\" or \"http://`hostname`${PORTEXT}\""
	elog "to check the status of your webCDwriter"
#	elog "3. Run \"/usr/sbin/CDWconfig.sh\" to set the rights of CDWserver"
	echo
	ewarn "Remember to setup /etc/CDWserver/config"
}
