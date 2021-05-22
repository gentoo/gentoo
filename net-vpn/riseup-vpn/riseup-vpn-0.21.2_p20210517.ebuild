# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="sphinx"
DOCS_DIR="docs"
DOCS_DEPEND="dev-python/alabaster"

PYTHON_COMPAT=( python3_{7..10} )

inherit desktop python-r1 docs go-module virtualx xdg

EGO_SUM=(
	"0xacab.org/leap/shapeshifter v0.0.0-20191029173606-85d3e8ac43e2"
	"0xacab.org/leap/shapeshifter v0.0.0-20191029173606-85d3e8ac43e2/go.mod"
	"github.com/OperatorFoundation/obfs4 v0.0.0-20161108041644-17f2cb99c264"
	"github.com/OperatorFoundation/obfs4 v0.0.0-20161108041644-17f2cb99c264/go.mod"
	"github.com/OperatorFoundation/shapeshifter-ipc v0.0.0-20170814234159-11746ba927e0"
	"github.com/OperatorFoundation/shapeshifter-ipc v0.0.0-20170814234159-11746ba927e0/go.mod"
	"github.com/OperatorFoundation/shapeshifter-transports v0.0.0-20191101030951-7a751b0500f4"
	"github.com/OperatorFoundation/shapeshifter-transports v0.0.0-20191101030951-7a751b0500f4/go.mod"
	"github.com/ProtonMail/go-autostart v0.0.0-20181114175602-c5272053443a"
	"github.com/ProtonMail/go-autostart v0.0.0-20181114175602-c5272053443a/go.mod"
	"github.com/agl/ed25519 v0.0.0-20170116200512-5312a6153412"
	"github.com/agl/ed25519 v0.0.0-20170116200512-5312a6153412/go.mod"
	"github.com/apparentlymart/go-openvpn-mgmt v0.0.0-20161009010951-9a305aecd7f2"
	"github.com/apparentlymart/go-openvpn-mgmt v0.0.0-20161009010951-9a305aecd7f2/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/dchest/siphash v1.2.1"
	"github.com/dchest/siphash v1.2.1/go.mod"
	"github.com/kardianos/osext v0.0.0-20190222173326-2bc1f35cddc0"
	"github.com/kardianos/osext v0.0.0-20190222173326-2bc1f35cddc0/go.mod"
	"github.com/keybase/go-ps v0.0.0-20190827175125-91aafc93ba19"
	"github.com/keybase/go-ps v0.0.0-20190827175125-91aafc93ba19/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rakyll/statik v0.1.7"
	"github.com/rakyll/statik v0.1.7/go.mod"
	"github.com/sevlyar/go-daemon v0.1.5"
	"github.com/sevlyar/go-daemon v0.1.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191105034135-c7e5f84aec59"
	"golang.org/x/crypto v0.0.0-20191105034135-c7e5f84aec59/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b"
	"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20200212091648-12a6c2dcc1e4"
	"golang.org/x/sys v0.0.0-20200212091648-12a6c2dcc1e4/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	)
go-module_set_globals

COMMIT="c6c0209ad45fb7d2e45370ee3a39f2dd437603b0"

DESCRIPTION="Anonymous encrypted VPN client powered by Bitmask"
HOMEPAGE="https://riseup.net/en/vpn https://0xacab.org/leap/bitmask-vpn https://bitmask.net"
SRC_URI="https://0xacab.org/leap/bitmask-vpn/-/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

# Generated with dev-go/golicense
LICENSE="GPL-3 BSD-2 CC0-1.0 MIT BSD"
KEYWORDS="~amd64"
SLOT="0"

BDEPEND="
	virtual/pkgconfig
	dev-qt/linguist-tools
	test? ( dev-qt/qttest:5 )
"

DEPEND="${PYTHON_DEPS}
	dev-libs/libappindicator:3
	sys-apps/fakeroot
	x11-libs/gtk+:3
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtquickcontrols2:5[widgets]
"

RDEPEND="${DEPEND}
	net-vpn/openvpn
	sys-auth/polkit
"

# ip command is in bin instead of sbin on Gentoo
PATCHES=( "${FILESDIR}/${PN}-ip-location.patch" )

S="${WORKDIR}/bitmask-vpn-${COMMIT}"

src_prepare() {
	default

	# do not pre-strip
	sed -i -e '/strip $RELEASE\/$TARGET/d' gui/build.sh || die

	# add autodoc to the extensions because this actually
	# does require extra dependencies
	sed -i -e "/^extensions = \[/a \ \ \ \ \'sphinx.ext.autodoc\'," docs/conf.py || die
}

src_compile() {
	# does not build with j>1
	emake -j1 build
	docs_compile
}

src_test() {
	# these tests require internet access to connect to Riseup Networks
	# the UI tests do work though
	#emake test
	virtx emake test_ui
}

src_install() {
	einstalldocs

	dobin "build/qt/release/riseup-vpn"

	python_scriptinto /usr/sbin
	python_foreach_impl python_doscript "helpers/bitmask-root"

	insinto /usr/share/polkit-1/actions
	newins "helpers/se.leap.bitmask.policy" se.leap.bitmask.riseupvpn.policy

	newicon -s scalable "providers/riseup/assets/icon.svg" riseup.svg
	make_desktop_entry "${PN}" RiseupVPN riseup Network
}

pkg_postinst() {
	xdg_pkg_postinst
	go-module_pkg_postinst
}
