# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="arduino.cc/arduino-builder/..."

EGO_VENDOR=(
	"github.com/go-errors/errors a41850380601eeb43f4350f7d17c6bbd8944aaf8"
	"github.com/jstemmer/go-junit-report 833f8ea2b99d36d5f018698333834f3df200a0c2"
	"github.com/stretchr/testify 1661650f989674e3e5bcdcb805536e5d31481526"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="A command line tool for compiling Arduino sketches"
HOMEPAGE="https://github.com/arduino/arduino-builder"
SRC_URI="https://github.com/arduino/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-devel/crossdev
	dev-embedded/avrdude
	dev-embedded/arduino-ctags"

DEPEND=">=dev-lang/go-1.9.2"

src_unpack() {
	golang-vcs-snapshot_src_unpack
}

src_prepare() {
	# As we know, golang packages have to be compiled from namespace-aware paths which is the whole
	# point of the EGO_PN dance. arduino-builder goes a step further by re-creating its own
	# namespace inside its source package, messing up with our build process which can't find
	# packages. Also, our source package contains multiple namespaces which further messes with
	# messes with our vendoring process (each namespace needs its own vendor directory).
	# We do the following to try to work around this mess. It looks like upstream reworked this
	# in its master branch so we should be able to remove this in the upcoming major release.

	local deeppath="${S}/src/${EGO_PN%/...}"
	for pkgname in builder properties timeutils; do
		ln -s "${deeppath}/src/arduino.cc/${pkgname}" "${S}/src/arduino.cc/${pkgname}"
	done
	ln -s "${deeppath}/vendor/github.com" "${S}/src/github.com"

	# path paths so that they point to system ctags and avrdude
	eapply "${FILESDIR}/arduino-builder-1.3.25-platform-paths.patch"
	eapply "${FILESDIR}/arduino-builder-1.3.25-skip-tests.patch"

	default
}

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
	cd "src/arduino.cc/builder/hardware" || die
	doins "platform.txt"
	doins "platform.keys.rewrite.txt"
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-gcc ] && ewarn "Missing avr-gcc; you need to crossdev -s4 avr"
}
