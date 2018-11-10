# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://samtools.sourceforge.net/"
SRC_URI="https://github.com/samtools/samtools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0.1-legacy"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sys-libs/ncurses:0=
	dev-lang/perl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-buildsystem.patch"
)

src_prepare() {
	default
	# required, otherwise python_fix_shebang errors out
	sed -i 's~/software/bin/python~/usr/bin/env python~' misc/varfilter.py || die
	tc-export CC AR
}

src_compile() {
	local _ncurses="$($(tc-getPKG_CONFIG) --libs ncurses)"
	emake dylib LIBCURSES="${_ncurses}"
	emake LIBCURSES="${_ncurses}"
}

src_install() {
	# install executables and hide them away from sight
	dobin samtools bcftools/{bcftools,vcfutils.pl} misc/{*.py,*.pl,wgsim,ace2sam} \
		misc/{md5sum-lite,maq2sam-short,bamcheck,maq2sam-long,md5fa,plot-bamcheck}
	mv "${ED%/}"/usr/{bin,${PN}-${SLOT}} || die
	mkdir "${ED%/}"/usr/bin || die
	mv "${ED%/}"/usr/{${PN}-${SLOT},bin/} || die

	# ... do the same with the python script, but also fix the shebang
	mv "${ED%/}"/usr/bin/${PN}-${SLOT}/varfilter{,-${SLOT}}.py || die
	python_fix_shebang "${ED%/}"/usr/bin/${PN}-${SLOT}/varfilter-${SLOT}.py

	# fix perl shebangs
	pushd "${ED%/}"/usr/bin/${PN}-${SLOT} >/dev/null || die
		local i
		for i in plot-bamcheck *.pl; do
			sed -e '1s:.*:#!/usr/bin/env perl:' -i "${i}" || die
		done
	popd >/dev/null || die

	dolib.so libbam-${SLOT}$(get_libname 1)
	dosym libbam-${SLOT}$(get_libname 1) /usr/$(get_libdir)/libbam-${SLOT}$(get_libname)

	insinto /usr/include/bam-${SLOT}
	doins *.h

	mv ${PN}{,-${SLOT}}.1 || die
	doman ${PN}-${SLOT}.1
	einstalldocs

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	elog "This version of samtools should *not* be your first choice for working"
	elog "with NGS data. It is installed solely for programs requiring it."
	elog "It is recommended that you use >=sci-biology/samtools-1.2."
}
