# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

MY_P=linux-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Developer documentation generated from the Linux kernel"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="mirror://kernel/linux/kernel/v3.x/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

IUSE="html"
DEPEND="app-text/docbook-sgml-utils
		app-text/xmlto
		sys-apps/sed
		~app-text/docbook-xml-dtd-4.1.2"
RDEPEND=""

src_prepare() {

	sed -i \
		-e "s:db2:docbook2:g" \
		-e "s:/usr/local/man:${D}/usr/share/man:g" \
		"${S}"/Documentation/DocBook/Makefile

	# fix for parallel build as per bug #248337
	sed -i \
		-e "s:\$(Q)\$(MAKE) \$(build)=Documentation\/DocBook \$@:+\$(Q)\$(MAKE) \$(build)=Documentation\/DocBook \$@:" \
		"${S}"/Makefile
}

src_compile() {
	local ARCH=$(tc-arch-kernel)
	unset KBUILD_OUTPUT

	emake mandocs || die "make mandocs failed"

	if use html; then
		emake htmldocs || die "make htmldocs failed"
	fi
}

src_install() {
	local file
	local ARCH=$(tc-arch-kernel)
	unset KBUILD_OUTPUT

	make installmandocs || die "make installmandocs failed"

	if use html; then
		# There is no subdirectory named "index"
		dohtml Documentation/DocBook/index.html
		rm Documentation/DocBook/index.html
		for file in Documentation/DocBook/*.html; do
			dohtml -r ${file/\.html/}
		done
	fi
}
