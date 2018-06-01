# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="http://www.bzip.org/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/hanetzer/bzip2"
	inherit autotools git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
	SRC_URI="mirror://gentoo/${P}.tar.gz"
fi

LICENSE="BZIP2"
SLOT="0/1" # subslot = SONAME
IUSE="static static-libs"

DOCS=( manual.pdf CHANGES NEWS README.autotools README README.XML.STUFF )
HTML_DOCS=( manual.html )

src_prepare() {
	default
	if [[ ${PV} == *9999* ]]; then
		eautoreconf
	fi
}

multilib_src_configure() {
	# use static && append-ldflags -static # doesn't seem to work...
	# fails at gen_usr_ldscript because adding -static to ldflags
	# prevents generation of libbz2.so

	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D%/}" install
	gen_usr_ldscript -a bz2
}

multilib_src_install_all() {
	default
	find "${D%/}" -name '*.la' -delete || die
	mkdir -p "${D%/}/bin" || die
	for i in bzip2$(get_exeext) bunzip2$(get_exeext) bzcat$(get_exeext); do
		mv "${D%/}/usr/bin/$i" "${D%/}/bin/" || die
	done
}
