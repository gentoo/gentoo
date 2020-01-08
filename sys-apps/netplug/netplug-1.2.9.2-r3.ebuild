# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Brings up/down ethernet ports automatically with cable detection"
HOMEPAGE="https://www.red-bean.com/~bos/"
SRC_URI="https://www.red-bean.com/~bos/netplug/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc"

DEPEND="doc? ( app-text/ghostscript-gpl
		media-gfx/graphviz )"
RDEPEND=""

PATCHES=(
	# Remove nested functions, #116140
	"${FILESDIR}/${PN}-1.2.9-remove-nest.patch"

	# Ignore wireless events
	"${FILESDIR}/${PN}-1.2.9-ignore-wireless.patch"

	# Fix DOWNANDOUT problem #599400
	"${FILESDIR}/${P}-downandout.patch"

	# Wait for multiple children in SIGCHLD handler #631316
	"${FILESDIR}/${P}-multi-waitpid-sigchld.patch"
)

src_prepare() {
	# Remove debug flags from CFLAGS
	if ! use debug ; then
		sed -i -e "s/ -ggdb3//" Makefile || die
	fi

	# Remove -O3 and -Werror from CFLAGS
	sed -i -e "s/ -O3//" -e "s/ -Werror//" Makefile || die

	default
}

src_compile() {
	tc-export CC
	emake CC="${CC}"

	if use doc ; then
		emake -C docs/
	fi
}

src_install() {
	into /
	dosbin netplugd
	doman man/man8/netplugd.8

	dodir /etc/netplug.d
	exeinto /etc/netplug.d
	newexe "${FILESDIR}/netplug-2" netplug

	dodir /etc/netplug
	echo "eth*" > "${ED}"/etc/netplug/netplugd.conf || die

	dodoc ChangeLog NEWS README TODO

	if use doc; then
		dodoc docs/state-machine.ps
	fi
}
