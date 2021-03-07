# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/arduino/arduino-builder/..."

EGO_VENDOR=(
	"github.com/arduino/go-properties-map ad37f0cfeff29fadeabe6b2f7f852d8db1fb5c41"
	"github.com/arduino/go-timeutils d1dd9e313b1bfede35fe0bbf46d612e16a50e04e"
	"github.com/arduino/go-paths-helper 751652ddd9f0a98650e681673c2c73937002e889"
	"github.com/fsnotify/fsnotify c2828203cd70a50dcccfb2761f8b1f8ceef9a8e9"
	"github.com/go-errors/errors a41850380601eeb43f4350f7d17c6bbd8944aaf8"
	"github.com/golang/protobuf aa810b61a9c79d51363740d207bb46cf8e620ed5"
	"github.com/jstemmer/go-junit-report 833f8ea2b99d36d5f018698333834f3df200a0c2"
	"github.com/stretchr/testify 1661650f989674e3e5bcdcb805536e5d31481526"
	"google.golang.org/grpc 8dea3dc473e90c8179e519d91302d0597c0ca1d1 github.com/grpc/grpc-go"
	"google.golang.org/genproto af9cb2a35e7f169ec875002c1829c9b315cddc04 github.com/google/go-genproto"
	"golang.org/x/net ed066c81e75eba56dd9bd2139ade88125b855585 github.com/golang/net"
	"golang.org/x/text e6919f6577db79269a6443b9dc46d18f2238fb5d github.com/golang/text"
	"golang.org/x/sys 11f53e03133963fb11ae0588e08b5e0b85be8be5 github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="A command line tool for compiling Arduino sketches"
HOMEPAGE="https://github.com/arduino/arduino-builder"
SRC_URI="https://github.com/arduino/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-devel/crossdev
	dev-embedded/avrdude
	dev-embedded/arduino-ctags"

DEPEND=">=dev-lang/go-1.9.2"

PATCHES=(
	"${FILESDIR}/arduino-builder-1.4.1-platform-paths.patch"
	"${FILESDIR}/arduino-builder-1.4.1-skip-tests.patch"
)

src_install() {
	# we unfortunately have to copy/paste the contents of golang-build_src_install() here because
	# we *don't* want to call golang_install_pkgs() which installs all static libraries we've
	# built. All we want is to install the final executable.

	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	echo "$@"
	"$@" || die

	# END OF COPY/PASTE

	dobin bin/arduino-builder
	# In addition to the binary, we also want to install these two files below. They are needed by
	# the dev-embedded/arduino which copies those files in its "hardware" folder.
	insinto "/usr/share/${PN}"
	cd "src/github.com/arduino/arduino-builder/hardware" || die
	doins "platform.txt"
	doins "platform.keys.rewrite.txt"
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to crossdev -s4 avr"
}
