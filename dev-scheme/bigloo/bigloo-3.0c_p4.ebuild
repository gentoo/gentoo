# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit elisp-common multilib java-pkg-opt-2

MY_P=${PN}${PV/_p/-}
MY_P=${MY_P/_alpha/-alpha}
MY_P=${MY_P/_beta/-beta}

DESCRIPTION="Bigloo is a Scheme implementation"
HOMEPAGE="http://www-sop.inria.fr/mimosa/fp/Bigloo/bigloo.html"
SRC_URI="ftp://ftp-sop.inria.fr/mimosa/fp/Bigloo/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

DEPEND="emacs? ( virtual/emacs )
		java? ( >=virtual/jdk-1.5 )"

RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.5 )"

S=${WORKDIR}/${MY_P%-*}

SITEFILE="50bigloo-gentoo.el"

IUSE="emacs java"
# fullbee"

src_prepare() {
	sed -i -e 's/^cstrip="-s"/cstrip="no"/' \
		-e 's/STRIP=$strip/STRIP=true/' \
		configure || die
}

src_configure() {
	# Bigloo doesn't use autoconf and consequently a lot of options used by econf give errors
	# Manuel Serrano says: "Please, dont talk to me about autoconf. I simply dont want to hear about it..."
	./configure \
		$(use java && echo "--jvm=yes --java=$(java-config --java) --javac=$(java-config --javac)") \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--libdir=/usr/$(get_libdir) \
		--docdir=/usr/share/doc/${PF} \
		--benchmark=yes \
		--sharedbde=no \
		--sharedcompiler=no \
		--coflags="" || die "configure failed"

#		--bee=$(if use fullbee; then echo full; else echo partial; fi) \

}

src_compile() {
	if use emacs; then
		elisp-compile etc/*.el || die "elisp-compile failed"
	fi

	# parallel build is broken
	emake -j1 || die "emake failed"
}

src_install () {
#	dodir /etc/env.d
#	echo "LDPATH=/usr/$(get_libdir)/bigloo/${PV}/" > ${D}/etc/env.d/25bigloo

	# make the links created not point to DESTDIR, since that is only a temporary home
	sed 's/ln -s $(DESTDIR)/ln -s /' -i Makefile.misc
	emake -j1 DESTDIR="${D}" install || die "install failed"

	if use emacs; then
		elisp-install ${PN} etc/*.{el,elc} || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

#	einfo "Compiling bee..."
#	emake compile-bee || die "compiling bee failed"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
