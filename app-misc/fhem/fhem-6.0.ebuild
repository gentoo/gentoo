# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="A GPL'd perl server for house automation"
HOMEPAGE="https://www.fhem.de/"
SRC_URI="https://www.fhem.de/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc"

RDEPEND="
	acct-group/fhem
	acct-user/fhem
	dev-perl/Crypt-CBC
	dev-perl/Device-SerialPort
	dev-perl/Digest-CRC
	dev-perl/JSON
"

DEPEND="media-gfx/pngcrush"

src_prepare() {
	default

	# Allow install path to be set by DESTDIR in Makefile
	sed -i -e 's,^\(BINDIR=\),\1'\$\(DESTDIR\)',' Makefile || die

	# Remove docs in Makefile, as they will be installed manually
	sed -i -e 's/docs//g' Makefile || die
	sed -i -e '/README_DEMO.txt/d' Makefile || die

	# Remove manpage in Makefile, as it will be installed manually
	sed -i -e '/fhem.pl.1/d' Makefile || die

	# Remove lcd4linux binaries, as they are provied by app-misc/lcd4linux
	rm -r contrib/lcd4linux || die

	# Remove log dir, as it will be replaced with a symlink
	rm -r log || die

	# Fix fhemicon_darksmall.png, as it reports "broken IDAT window length"
	# Reported to Upstream: https://forum.fhem.de/index.php/topic,86238.0.html
	pngcrush -fix -force -ow www/images/default/fhemicon_darksmall.png || die

	cp "${FILESDIR}"/fhem.cfg fhem.cfg || die
}

src_compile() {
	:
}

src_install() {
	local DOCS=(
		"CHANGED"
		"HISTORY"
		"MAINTAINER.txt"
		"README.SVN"
		"README_DEMO.txt"
		"docs"/*.txt
		"docs"/*.patch
		"docs"/*.pdf
		"docs/changelog"
		"docs/copyright"
		"docs/dotconfig"
		"docs/fhem.odg.readme"
		"docs/LIESMICH.update-thirdparty"
		"docs"/README*
		"docs/X10"
	)

	if use doc; then
		local DOCS+=( "docs/X10" )
		local HTML_DOCS=( "docs/"*.eps "docs/"*.html "docs"/*.jpg "docs"/*.js "docs"/*.odg "docs/"*.png "docs/km271" )
	fi

	diropts -o fhem -g fhem
	keepdir "/var/lib/fhem"
	keepdir "/var/log/fhem"
	diropts

	dosym ../../var/lib/fhem /opt/fhem/data
	dosym ../../var/log/fhem /opt/fhem/log

	default

	newinitd "${FILESDIR}"/fhem.initd fhem

	systemd_dounit "${FILESDIR}"/fhem.service
	systemd_newtmpfilesd "${FILESDIR}"/fhem.tmpfiles fhem.conf

	newman docs/fhem.man fhem.pl.1

	echo 'CONFIG_PROTECT="/opt/fhem /var/lib/fhem"' > "${T}"/99fhem || die
	doenvd "${T}"/99fhem

	fowners fhem:fhem /opt/fhem/fhem.cfg
}
