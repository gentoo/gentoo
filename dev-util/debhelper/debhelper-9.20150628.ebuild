# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/debhelper/debhelper-9.20150628.ebuild,v 1.1 2015/06/29 06:05:57 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Collection of programs that can be used to automate common tasks in debian/rules"
HOMEPAGE="http://packages.qa.debian.org/d/debhelper.html http://joeyh.name/code/debhelper/"
SRC_URI="mirror://debian/pool/main/d/${PN}/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux"
IUSE="test"
DH_LINGUAS=( de es fr )
IUSE+=" ${DH_LINGUAS[@]/#/linguas_}"

NLS_DEPEND=$(
	printf "linguas_%s? ( >=app-text/po4a-0.24 )\n" ${DH_LINGUAS[@]}
)

RDEPEND="
	>=dev-lang/perl-5.10:=
	>=app-arch/dpkg-1.17
	dev-perl/TimeDate
	virtual/perl-Getopt-Long
"
DEPEND="${RDEPEND}
	${NLS_DEPEND}
	test? ( dev-perl/Test-Pod )
"

S=${WORKDIR}/${PN}

src_compile() {
	tc-export CC

	local LANGS="" USE_NLS=no lingua
	for lingua in ${DH_LINGUAS[@]}; do
		if use linguas_${lingua}; then
			LANGS+=" ${lingua}"
			USE_NLS=yes
		fi
	done

	emake USE_NLS="${USE_NLS}" LANGS="${LANGS}" build
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc doc/* debian/changelog
	docinto examples
	dodoc examples/*
	local lingua
	for manfile in *.1 *.7 ; do
		for lingua in ${DH_LINGUAS[@]}; do
			case ${manfile} in
				*.${lingua}.?)
					use linguas_${lingua} \
						&& cp ${manfile} "${T}"/${manfile/.${lingua}/} \
						&& doman -i18n=${lingua} "${T}"/${manfile/.${lingua}/}
					;;
				*)
					doman ${manfile}
					;;
			esac
		done
	done
}
