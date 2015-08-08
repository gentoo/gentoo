# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils elisp-common multilib toolchain-funcs versionator

CPV=($(get_version_components ${PV}))
CMT_PV=v${CPV[0]}r${CPV[1]}

DESCRIPTION="Cross platform configuration management environment"
HOMEPAGE="http://www.cmtsite.net/"
SRC_URI="http://www.cmtsite.net/${CMT_PV}/CMT${CMT_PV}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs java doc"

DEPEND="emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}
	java? ( virtual/jdk )"

S="${WORKDIR}/CMT/${CMT_PV}"

src_configure() {
	cd "${S}"/mgr || die
	./INSTALL || die
	source setup.sh
}

src_compile() {
	cd "${S}"/mgr || die
	emake \
		cpp="$(tc-getCXX)" \
		cppflags="${CXXFLAGS}" \
		cpplink="$(tc-getCXX) ${LDFLAGS}"

	sed -i -e "s:${WORKDIR}:${EPREFIX}/usr/$(get_libdir):g" setup.*sh || die
	cd "${S}" || die
	mv src/demo . || die
	rm ${CMTBIN}/*.o || die

	use emacs && elisp-compile doc/cmt-mode.el
}

src_install() {
	CMTDIR=/usr/$(get_libdir)/CMT/${CMT_PV}
	dodir ${CMTDIR}
	cp -pPR mgr src ${CMTBIN} "${ED}"/${CMTDIR} || die
	dodir /usr/bin
	dosym ${CMTDIR}/${CMTBIN}/cmt.exe /usr/bin/cmt

	cat > 99cmt <<-EOF
		 CMTROOT="${EROOT%/}${CMTDIR}"
		 CMTBIN="$(uname)-$(uname -m | sed -e 's# ##g')"
		 CMTCONFIG="$(${CMTROOT}/mgr/cmt_system.sh)"
	EOF
	if use java; then
		cp -pPR java "${ED}"/${CMTDIR}
		echo "#!${EPREFIX}/bin/sh" > jcmt
		echo "java cmt_parser" >> jcmt
		dobin jcmt
		echo "CLASSPATH=\"${CMTDIR}/java/cmt.jar\"" >> 99cmt
	fi

	doenvd 99cmt
	dodoc ChangeLog doc/*.txt
	dohtml doc/{ChangeLog,ReleaseNotes}.html

	if use doc; then
		emake -C mgr gendoc
		insinto /usr/share/doc/${PF}
		doins -r doc/{CMTDoc,CMTFAQ}.{html,pdf} doc/Images
		doins -r demo
	fi

	if use emacs; then
		elisp-install ${PN} doc/cmt-mode.{el,elc} || die
		elisp-site-file-install "${FILESDIR}"/80cmt-mode-gentoo.el || die
	fi
}

pkg_postinst () {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
