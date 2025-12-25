# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-$(ver_cut 1-3)-b.$(ver_cut 5)"

inherit multiprocessing

SRC_URI="https://pkg.cppget.org/1/beta/${PN}/${MY_P}.tar.gz"
KEYWORDS='~amd64 ~x86'
DESCRIPTION='Streaming XML pull parser/serializer for modern C++'
HOMEPAGE='https://www.codesynthesis.com/projects/libstudxml'
LICENSE='MIT'

SLOT='0'
IUSE='test'
RESTRICT='!test? ( test )'

BDEPEND='dev-util/build2'

S="${WORKDIR}/${MY_P}"

src_configure() {
	b configure \
		config.cc.coptions="${CFLAGS}" \
		config.cc.loptions="${LDFLAGS}" \
		config.cxx.coptions="${CXXFLAGS}" \
		config.cxx.loptions="${LDFLAGS}" \
		--jobs $(makeopts_jobs)	\
		--no-progress \
		--verbose 2
}

src_compile() {
	b update-for-install \
		--jobs $(makeopts_jobs) \
		--no-progress \
		--verbose 2
	use test && b update-for-test \
		--jobs $(makeopts_jobs) \
		--no-progress \
		--verbose 2
}

src_test() {
	b test \
		--jobs $(makeopts_jobs) \
		--no-progress \
		--verbose 2
}

src_install() {
	b install \
		config.install.chroot="${D}" \
                config.install.root="${EPREFIX}"/usr \
                config.install.lib="${EPREFIX}"/usr/$(get_libdir) \
                config.install.doc="${EPREFIX}"/usr/share/doc/${PF} \
		--no-progress
}
