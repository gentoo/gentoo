# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper

DESCRIPTION="Scheme interpreter, compiler, debugger and runtime library"
HOMEPAGE="https://www.gnu.org/software/mit-scheme/
	https://savannah.gnu.org/projects/mit-scheme/"
SRC_URI="https://ftp.gnu.org/gnu/${PN}/stable.pkg/${PV}/${P}-svm1-64le.tar.gz"
S="${S}"/src

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"  # Additionally arm64 is officially supported.
IUSE="blowfish gdbm gui postgres"

RDEPEND="
	blowfish? ( dev-libs/openssl:= )
	gdbm? ( sys-libs/gdbm:= )
	gui? ( x11-libs/libX11 )
	postgres? ( dev-db/postgresql:* )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-11.2-no-Werror.patch
	"${FILESDIR}"/${PN}-11.2-implicit-int.patch
)

src_configure() {
	local -a myconf=(
		--disable-mcrypt
		$(use_enable blowfish)
		$(use_enable gdbm)
		$(use_enable gui edwin)
		$(use_enable gui imail)
		$(use_enable gui x11)
		$(use_enable postgres pgsql)
		$(use_with gui x)
	)
	econf ${myconf[@]}
}

src_compile() {
	# Compile the "microcode" first, bug #879901
	emake -C microcode

	# Fails with multiple make-jobs, at least it compiles relatively fast.
	emake -j1
}

# Tests that theoretically fail (still passes):
# microcode/test-flonum-except
# runtime/test-arith
# runtime/test-flonum
# runtime/test-flonum.bin
# runtime/test-flonum.com

src_test() {
	FAST=y emake check -j1
}

src_install() {
	default

	# Create the edwin launcher.
	use gui && make_wrapper mit-scheme-edwin "mit-scheme --edit"

	# Remove "scheme" symlink to not "discriminate" any other implementations.
	rm "${ED}"/usr/bin/scheme || die

	# Remove libtool files.
	find "${ED}" -type f -name "*.la" -delete || die
}
