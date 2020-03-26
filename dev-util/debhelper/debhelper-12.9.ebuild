# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils toolchain-funcs

DESCRIPTION="Collection of programs that can be used to automate common tasks in debian/rules"
HOMEPAGE="https://tracker.debian.org/pkg/debhelper"
SRC_URI="mirror://debian/pool/main/d/${PN}/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux"
IUSE="test"
RESTRICT="!test? ( test )"
DH_LANGS=( de es fr )
IUSE+=" ${DH_LANGS[@]/#/l10n_}"

NLS_DEPEND=$(
	printf "l10n_%s? ( >=app-text/po4a-0.24 )\n" ${DH_LANGS[@]}
)

RDEPEND="
	>=dev-lang/perl-5.10:=
	>=app-arch/dpkg-1.17
	dev-perl/TimeDate
	virtual/perl-Getopt-Long
"
DEPEND="
	${RDEPEND}
	${NLS_DEPEND}
	test? (
		dev-perl/Test-Pod
		sys-apps/fakeroot
	)
"

S=${WORKDIR}/${PN}

src_compile() {
	tc-export CC

	local LANGS="" USE_NLS=no lang
	for lang in ${DH_LANGS[@]}; do
		if use l10n_${lang}; then
			LANGS+=" ${lang}"
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
	local lang
	for manfile in *.1 *.7 ; do
		for lang in ${DH_LANGS[@]}; do
			case ${manfile} in
				*.${lang}.?)
					use l10n_${lang} \
						&& cp ${manfile} "${T}"/${manfile/.${lang}/} \
						&& doman -i18n=${lang} "${T}"/${manfile/.${lang}/}
					;;
				*)
					doman ${manfile}
					;;
			esac
		done
	done
}
