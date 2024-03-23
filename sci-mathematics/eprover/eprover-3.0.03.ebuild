# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Automated theorem prover for full first-order logic with equality"
HOMEPAGE="https://www.eprover.org/
	https://github.com/eprover/eprover/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/eprover/${PN}.git"
else
	SRC_URI="https://github.com/eprover/${PN}/archive/E-${PV/_/}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-E-${PV/_/}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="+ho"

BDEPEND="
	sys-apps/help2man
"

PATCHES=( "${FILESDIR}/${PN}-3.0.03-unistd.patch" )

src_prepare() {
	default

	sed -e "/^OPTFLAGS/s|= .*|= ${CFLAGS}|"			\
		-e "/^LD/s|= .*|= $(tc-getCC) ${LDFLAGS}|"	\
		-e "/^   AR/s|ar|$(tc-getAR)|"				\
		-e "/^   CC/s|gcc|$(tc-getCC)|"				\
		-i "${S}/Makefile.vars" || die

	sed -e "s|ar rc|$(tc-getAR) rc|g"						\
		-e "s|ranlib|$(tc-getRANLIB)|g"						\
		-i "${S}/CONTRIB/picosat-965/makefile.in" || die
}

src_configure() {
	local -a myconf=(
		$(usex ho '--enable-ho' '')
		--bindir=/usr/bin
		--exec-prefix=/usr
		--man-prefix=/usr/share/man/man1
	)
	sh ./configure "${myconf[@]}" || die
}

src_compile() {
	default

	if use ho ; then
		ln -s "${S}/PROVER/${PN}-ho" "${S}/PROVER/${PN}" || die
	fi

	emake man
}

src_install() {
	# Picosat (CONTRIB package) is available as separate package.
	rm -r "${S}/CONTRIB" || die

	emake EXECPATH="${ED}/usr/bin" MANPATH="${ED}/usr/share/man/man1" install
	dodoc -r DOC EXAMPLE_PROBLEMS

	if use ho ; then
		dosym -r "/usr/bin/${PN}-ho" "/usr/bin/${PN}"
	fi
}
