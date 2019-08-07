# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib

# weird failures
RESTRICT="test"

DESCRIPTION="Virtual machine designed to compile and execute bytecode for dynamic languages"
HOMEPAGE="http://www.parrot.org/"
SRC_URI="ftp://ftp.parrot.org/pub/parrot/releases/all/${PV}/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="opengl nls doc examples gdbm +gmp ssl +unicode pcre"

CDEPEND="sys-libs/readline:0=
	dev-libs/libffi
	net-libs/libnsl:0=
	opengl? ( media-libs/freeglut )
	nls? ( sys-devel/gettext )
	unicode? ( >=dev-libs/icu-2.6:= )
	gdbm? ( >=sys-libs/gdbm-1.8.3-r1 )
	gmp? ( >=dev-libs/gmp-4.1.4:0= )
	ssl? ( dev-libs/openssl:0= )
	pcre? ( dev-libs/libpcre )
"
RDEPEND="${CDEPEND}
	doc? ( dev-perl/JSON )"
DEPEND="${CDEPEND}"
BDEPEND="dev-lang/perl[doc?]
	${RDEPEND}"

src_configure() {
	myconf="--disable-rpath"
	use unicode || myconf+=" --without-icu"
	use ssl     || myconf+=" --without-crypto"
	use gdbm    || myconf+=" --without-gdbm"
	use nls     || myconf+=" --without-gettext"
	use gmp     || myconf+=" --without-gmp"
	use opengl  || myconf+=" --without-opengl"
	use pcre    || myconf+=" --without-pcre"

	perl Configure.pl \
		--ccflags="${CFLAGS}" \
		--linkflags="${LDFLAGS}" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--mandir="${EPREFIX}"/usr/share/man \
		--sysconfdir="${EPREFIX}"/etc \
		--sharedstatedir="${EPREFIX}"/var/lib/parrot \
		$myconf || die
}

src_compile() {
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}"${S}"/blib/lib
	# occasionally dies in parallel make
	emake -j1
	if use doc ; then
		emake -j1 html
	fi
}

src_test() {
	emake -j1 test
}

src_install() {
	emake -j1 install-dev DESTDIR="${D}" DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
	dosym parrot-ops2c /usr/bin/ops2c
	rm -vfr "${ED}/usr/share/doc/${PF}/parrot" || die "Unable to prune excess docs"
	DOCS=(
		CREDITS
		ChangeLog
		DONORS.pod
		PBC_COMPAT
		PLATFORMS
		README.pod
		RESPONSIBLE_PARTIES
		TODO
	)
	use doc && DOCS+=( editor )
	use examples && DOCS+=( examples )
	use doc && HTML_DOCS=(
			docs/html/developer.html
			docs/html/DONORS.pod.html
			docs/html/index.html
			docs/html/ops.html
			docs/html/parrotbug.html
			docs/html/pdds.html
			docs/html/pmc.html
			docs/html/tools.html
			docs/html/docs
			docs/html/src
			docs/html/tools
	)
	einstalldocs
}
