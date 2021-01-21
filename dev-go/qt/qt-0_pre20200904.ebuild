# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/therecipe/qt"
EGO_VENDOR=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/gopherjs/gopherjs bd77b112433e"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.2"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/sirupsen/logrus v1.4.1"
	"github.com/stretchr/objx v0.1.0"
	"github.com/stretchr/objx v0.1.1"
	"github.com/stretchr/objx v0.2.0"
	"github.com/stretchr/testify v1.2.2"
	"github.com/stretchr/testify v1.3.0"
	"golang.org/x/crypto df01cb2cc480 github.com/golang/crypto"
	"golang.org/x/net afa5a82059c6 github.com/golang/net"
	"golang.org/x/sys e8e3143a4f4a github.com/golang/sys"
	"golang.org/x/sys e8e3143a4f4a github.com/golang/sys"
	"golang.org/x/text f4905fbd45b6 github.com/golang/text"
	"golang.org/x/tools aa740d480789 github.com/golang/tools"
)

inherit golang-vcs-snapshot xdg-utils

EGIT_COMMIT="c0c124a5770d357908f16fa57e0aa0ec6ccd3f91"

DESCRIPTION="Qt5 Go bindings"
HOMEPAGE="https://github.com/therecipe/qt/"
SRC_URI="https://github.com/therecipe/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

# As of 2021-01-20 the test 'widgets/textedit' calls methods which do not exist, at least in qt-5.15.
# TODO: figure out how to disable this test.
RESTRICT="test"

# We need qt-docs[html] because binding generation depends on core .index files
# installed by this USE flag.
RDEPEND="dev-qt/designer:5=
	dev-qt/qt-docs:5=[html]
	dev-qt/qtbluetooth:5=
	dev-qt/qtcharts:5=
	dev-qt/qtcore:5=
	dev-qt/qtdatavis3d:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgamepad:5=
	dev-qt/qthelp:5=
	dev-qt/qtlocation:5=
	dev-qt/qtmultimedia:5=[widgets]
	dev-qt/qtpositioning:5=
	dev-qt/qtquickcontrols2:5=
	dev-qt/qtscxml:5=
	dev-qt/qtsensors:5=
	dev-qt/qtserialbus:5=
	dev-qt/qtserialport:5=
	dev-qt/qtspeech:5=
	dev-qt/qtsql:5=
	dev-qt/qtsvg:5=
	dev-qt/qtvirtualkeyboard:5=
	dev-qt/qtwebchannel:5=
	dev-qt/qtwebengine:5=
	dev-qt/qtwebsockets:5=
	dev-qt/qtwebview:5=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0_pre20200904-disable_modules.patch
)

src_prepare() {
	xdg_environment_reset
	default
}

src_configure() {
	export GOPATH="${WORKDIR}"/${P}
	export QT_PKG_CONFIG=true
	export QT_DOC_DIR="${EPREFIX}/usr/share/qt5-doc"
}

src_compile() {
	# Not a typo, all that gets installed here is the bootstrap for generating
	# and building actual bindings
	go install -v -work -x -tags=no_env ${EGO_PN}/cmd/... || die

	"${GOPATH}"/bin/qtsetup -failfast -test=false || die
}

src_test() {
	"${GOPATH}"/bin/qtsetup -failfast test || die
}

src_install() {
	# Just in case
	unset GOPATH

	rm -rf src/${EGO_PN}/vendor
	rm -rf src/${EGO_PN}/.git*
	find src/${EGO_PN}/internal/examples -type d -name deploy -exec rm -rf {} \;
	find src/${EGO_PN} -name '*.c' -exec rm -f {} \;
	find src/${EGO_PN} -name '*.h' -exec rm -f {} \;

	insinto $(dirname "$(get_golibdir)/src/${EGO_PN%/*}")
	doins -r src/${EGO_PN%/*}

	insinto $(dirname "$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
	doins -r pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}

	# Not sure if we still need qtsetup - but just in case, install all binaries
	exeinto "$(get_golibdir)"/bin
	doexe bin/*
}
