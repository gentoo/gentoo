# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

MY_PN=ccl
MY_P=${MY_PN}-${PV}

DESCRIPTION="Common Lisp implementation, derived from Digitool's MCL product"
HOMEPAGE="http://ccl.clozure.com/"
SRC_URI="
	x86?   ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxx86.tar.gz )
	amd64? ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxx86.tar.gz )
	doc? ( http://ccl.clozure.com/docs/ccl.html )"
	# ppc?   ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxppc.tar.gz )
	# ppc64? ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxppc.tar.gz )"

LICENSE="LLGPL-2.1"
SLOT="0"
# KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-lisp/asdf-2.33-r3:="
DEPEND="${RDEPEND}
		!dev-lisp/openmcl"

S="${WORKDIR}"/${MY_PN}

ENVD="${T}"/50ccl

src_configure() {
	if use x86; then
		CCL_RUNTIME=lx86cl; CCL_HEADERS=x86-headers; CCL_KERNEL=linuxx8632
	elif use amd64; then
		CCL_RUNTIME=lx86cl64; CCL_HEADERS=x86-headers64; CCL_KERNEL=linuxx8664
	elif use ppc; then
		CCL_RUNTIME=ppccl; CCL_HEADERS=headers; CCL_KERNEL=linuxppc
	elif use ppc64; then
		CCL_RUNTIME=ppccl64; CCL_HEADERS=headers64; CCL_KERNEL=linuxppc64
	fi
}

src_prepare() {
	cp /usr/share/common-lisp/source/asdf/build/asdf.lisp tools/ || die
}

src_compile() {
	emake -C lisp-kernel/${CCL_KERNEL} clean
	emake -C lisp-kernel/${CCL_KERNEL} all CC="$(tc-getCC)"

	unset CCL_DEFAULT_DIRECTORY
	./${CCL_RUNTIME} -n -b -Q -e '(ccl:rebuild-ccl :full t)' -e '(ccl:quit)' || die "Compilation failed"

	# remove non-owner write permissions on the full-image
	chmod go-w ${CCL_RUNTIME}{,.image} || die

	esvn_clean
}

src_install() {
	local install_dir=/usr/$(get_libdir)/${PN}

	exeinto ${install_dir}
	# install executable
	doexe ${CCL_RUNTIME}
	# install core image
	cp ${CCL_RUNTIME}.image "${D}"/${install_dir} || die
	# install optional libraries
	dodir ${install_dir}/tools
	cp tools/*fsl "${D}"/${install_dir}/tools || die

	# until we figure out which source files are necessary for runtime
	# optional features and which aren't, we install all sources
	find . -type f -name '*fsl' -delete || die
	rm -f lisp-kernel/${CCL_KERNEL}/*.o || die
	cp -a compiler level-0 level-1 lib library \
		lisp-kernel scripts tools xdump contrib \
		"${D}"/${install_dir} || die
	cp -a ${CCL_HEADERS} "${D}"/${install_dir} || die

	make_wrapper ccl "${install_dir}/${CCL_RUNTIME}"

	echo "CCL_DEFAULT_DIRECTORY=${install_dir}" > "${ENVD}"
	doenvd "${ENVD}"

	dodoc doc/release-notes.txt
	use doc && dohtml "${DISTDIR}"/ccl.html
	use doc && dohtml -r examples
}
