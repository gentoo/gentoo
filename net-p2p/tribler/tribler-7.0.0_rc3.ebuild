# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils unpacker

schemadb="schema_sdb_v29.sql"

DESCRIPTION="Bittorrent client that does not require a website to discover content"
HOMEPAGE="https://www.tribler.org/"
# Temporary hack for Release Candidate versions
RC_PV="7.0.0-rc3"
SRC_URI="https://github.com/Tribler/tribler/releases/download/v${RC_PV}/Tribler-v${RC_PV}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1+ PSF-2.4 openssl wxWinLL-3.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+vlc"

RDEPEND="
	dev-lang/python:2.7[sqlite]
	dev-python/apsw
	dev-python/cherrypy
	dev-python/configobj
	dev-python/decorator
	dev-python/feedparser
	dev-python/gmpy
	dev-python/leveldb
	dev-python/m2crypto
	dev-python/matplotlib
	dev-python/meliae
	dev-python/netifaces
	dev-python/psutil
	dev-python/pyasn1
	dev-python/pycryptodome
	dev-python/PyQt5[network]
	dev-python/twisted-core
	dev-python/twisted-web
	dev-python/wxpython:=
	dev-libs/openssl:0[-bindist]
	net-libs/libtorrent-rasterbar[python]
	vlc? (
			media-video/vlc
			media-video/ffmpeg:0
		)"

DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

src_prepare() {
	## Temporary Release Candidate hack
	epatch "${FILESDIR}/${PN}-7.0.0-log2homedir.patch"
	epatch "${FILESDIR}/${PN}-7.0.0-fix-desktop.patch"
	eapply_user
}

src_compile() { #{ :; }
	python2 setup.py build
}

src_install() {
	echo "Optimizing Python files..."
	python2 setup.py install --root="${S}" --optimize=1

	#Remove the licenses scattered throughout
	rm Tribler/binary-LICENSE-postfix.txt # GPL-2 LGPL-2.1+ PSF-2.4 openssl wxWinLL-3.1

	dodir /usr/share/doc/${P}
	cp "${S}/LICENSE" "${D}/usr/share/doc/${P}/LICENSE.txt"
	cp "${S}/README.rst" "${D}/usr/share/doc/${P}/README.rst"

	# Upstream does not provide a proper install file, so we install it ourself.
	echo "Installing shared files..."

	dodir /usr/share/${PN}
	cp -R "${S}/TriblerGUI" "${D}/usr/share/${PN}" || die "Installation of TriblerGUI failed!"
	cp -R "${S}/Tribler" "${D}/usr/share/${PN}" || die "Installation of Tribler's shared files failed!"
	cp "${S}/Tribler/${schemadb}" "${D}/usr/share/${PN}/Tribler" || die "Installation of Tribler's DB failed."

	cp "logger.conf" "${D}/usr/share/${PN}/"
	cp "run_tribler.py" "${D}/usr/share/${PN}/"
	cp "check_os.py" "${D}/usr/share/${PN}/"
	dodir /usr/share/${PN}/twisted
	cp -R "${S}/twisted" "${D}/usr/share/${PN}/twisted"

	insinto /usr/bin
	doins debian/bin/${PN}
	fperms 0755 /usr/bin/${PN}

	# Create desktop icon
	insinto /usr/share/applications
	doins Tribler/Main/Build/Ubuntu/tribler.desktop

	insinto /usr/share/pixmaps
	doins Tribler/Main/Build/Ubuntu/tribler.xpm
	doins Tribler/Main/Build/Ubuntu/tribler_big.xpm
}
