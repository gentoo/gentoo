# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

<<<<<<< HEAD
inherit autotools toolchain-funcs pam flag-o-matic
=======
inherit autotools toolchain-funcs pam
>>>>>>> 3928948a06b (rebase)

DESCRIPTION="Simple module to authenticate users against their ssh-agent keys"
HOMEPAGE="http://pamsshagentauth.sourceforge.net"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/jbeverly/${PN}.git"
	inherit git-r3
else
	ED25519_DONNA_COMMIT="8757bd4cd209cb032853ece0ce413f122eef212c"
	SRC_URI="https://github.com/jbeverly/pam_ssh_agent_auth/archive/refs/tags/${P}.tar.gz"
	SRC_URI+=" https://github.com/floodyberry/ed25519-donna/archive/${ED25519_DONNA_COMMIT}.tar.gz -> ${PN}-ed25519-donna.tar.gz"
	S="${WORKDIR}"/${PN}-${P}
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-libs/openssl:=
	sys-libs/pam
"
RDEPEND="
	${DEPEND}
	virtual/ssh
"
# Needed for pod2man
BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.4-0001-Fix-function-prototypes-in-configure.patch
	"${FILESDIR}"/${PN}-0.10.4-0002-Add-missing-includes-implicit-function-declarations.patch
)

src_prepare() {
	default

	# Missing from tag
	rm -r ed25519-donna || die
	ln -s "${WORKDIR}"/ed25519-donna-${ED25519_DONNA_COMMIT} "${S}"/ed25519-donna || die

	# For configure patches
	eautoreconf
}

src_configure() {
	pammod_hide_symbols

<<<<<<< HEAD
	# bug #874843, use POSIX type names
	use elibc_musl && append-cppflags -Du_char=uint8_t -Du_int=uint32_t

=======
>>>>>>> 3928948a06b (rebase)
	# bug #725720
	export AR="$(type -P $(tc-getAR))"

	econf \
		--without-openssl-header-check \
		--libexecdir="$(getpam_mod_dir)"
}

src_install() {
	# Don't use emake install as it makes it harder to have proper
	# install paths.
	dopammod pam_ssh_agent_auth.so
	doman pam_ssh_agent_auth.8

	dodoc CONTRIBUTORS
}
