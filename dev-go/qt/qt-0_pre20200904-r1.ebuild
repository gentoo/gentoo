# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module xdg-utils

# Warning: the current upstream go.sum is borked, this is what one gets having
# run 'go mod tidy' and subsequently removed the packages related to bundled Qt libs.
EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/golang/crypto v0.0.0-20190418165655-df01cb2cc480"
	"github.com/golang/crypto v0.0.0-20190418165655-df01cb2cc480/go.mod"
	"github.com/golang/net v0.0.0-20190420063019-afa5a82059c6/go.mod"
	"github.com/golang/sys v0.0.0-20190419153524-e8e3143a4f4a"
	"github.com/golang/sys v0.0.0-20190419153524-e8e3143a4f4a/go.mod"
	"github.com/golang/text v0.3.1-0.20190410012825-f4905fbd45b6/go.mod"
	"github.com/golang/tools v0.0.0-20190420181800-aa740d480789"
	"github.com/golang/tools v0.0.0-20190420181800-aa740d480789/go.mod"
	"github.com/gopherjs/gopherjs v0.0.0-20190411002643-bd77b112433e"
	"github.com/gopherjs/gopherjs v0.0.0-20190411002643-bd77b112433e/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.2"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.2/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/sirupsen/logrus v1.4.1"
	"github.com/sirupsen/logrus v1.4.1/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
)

go-module_set_globals

EGIT_COMMIT="c0c124a5770d357908f16fa57e0aa0ec6ccd3f91"

DESCRIPTION="Qt5 Go bindings"
HOMEPAGE="https://github.com/therecipe/qt/"
SRC_URI="https://github.com/therecipe/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

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
	"${FILESDIR}"/${PN}-0_pre20200904-r1-disable_modules.patch
	"${FILESDIR}"/${PN}-0_pre20200904-r1-unbundle_qt.patch
)

S="${WORKDIR}"/${PN}-${EGIT_COMMIT}

src_prepare() {
	xdg_environment_reset

	cp "${FILESDIR}"/${PN}-0_pre20200904-r1-go.mod go.mod || die
	cp "${FILESDIR}"/${PN}-0_pre20200904-r1-go.sum go.sum || die

	default
}

src_configure() {
	export QT_PKG_CONFIG=true
	export QT_DOC_DIR="${EPREFIX}/usr/share/qt5-doc"
}

src_compile() {
	# Not a typo, all that gets installed here is the bootstrap for generating
	# and building actual bindings
	go install -v -work -x -tags=no_env ./cmd/... || die

	# qtsetup uses GOFLAGS as 'go list' arguments
	GOFLAGS='' "$(go env GOPATH)"/bin/qtsetup -failfast -test=false || die
}

src_test() {
	GOOFLAGS='' "$(go env GOPATH)"/bin/qtsetup -failfast test || die
}

#src_install() {
#	local EGO_PN="github.com/therecipe/qt"
#
#	rm -rf vendor
#	rm -rf .git*
#	find internal/examples -type d -name deploy -exec rm -rf {} \;
#	find . -name '*.c' -exec rm -f {} \;
#	find . -name '*.h' -exec rm -f {} \;
#
#	insinto $(dirname "$(get_golibdir)/src/${EGO_PN%/*}")
#	doins -r src/${EGO_PN%/*}
#
#	insinto $(dirname "$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
#	doins -r pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}
#
#	# Not sure if we still need qtsetup - but just in case, install all binaries
#	exeinto "$(get_golibdir)"/bin
#	doexe bin/*
#}
