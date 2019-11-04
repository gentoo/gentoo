# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils fixheadtails toolchain-funcs

IUSE=""

MY_P=${PN}-${PV//./-}

DESCRIPTION="Protocol definitions of l7-filter kernel modules"
HOMEPAGE="http://l7-filter.sourceforge.net/protocols
	https://l7-filter.clearos.com/docs/start"

SRC_URI="mirror://sourceforge/l7-filter/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e "s|gcc.*\-o|$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o|" \
		-e "s|g++.*\-o|$(tc-getCXX) ${CFLAGS} ${LDFLAGS} -o|" \
			-i testing/Makefile || die
	sed -e "s|f in data|f in ${EPREFIX}/usr/share/l7-protocols/data|" \
		testing/timeit.sh || die
	ht_fix_file testing/*.sh
	eapply_user
}

src_compile() {
	emake -C testing
}

# NOTE Testing mechanism is currently broken:
#  stack smashing attack in function main()

# Is also extraordinarly inefficent getting random data.
#
#src_test() {
#	cd testing
#	find ${S} -name \*.pat -print -exec ./test_match.sh {} \; \
#		-exec ./timeit.sh {} \; || die "failed tests"
#	einfo "patterns past testing"
#}

src_install() {
	dodir /usr/{share,lib}/${PN}
	mv testing/data example_traffic "${ED}"/usr/share/${PN} || die

	pushd testing >/dev/null || die
	cp -pPR randprintable randchars test_speed-{kernel,userspace} README \
		match_kernel *.sh "${ED}"/usr/lib/${PN} || die
	popd >/dev/null || die

	dodoc README CHANGELOG HOWTO WANTED
	for dir in extra file_types malware ; do
		newdoc ${dir}/README README.${dir}
	done
	rm -rf README CHANGELOG HOWTO LICENSE Makefile WANTED */README testing || die

	dodir /etc/l7-protocols
	cp -R * "${ED}"/etc/l7-protocols || die
	chown -R root:0 "${ED}" || die
}
