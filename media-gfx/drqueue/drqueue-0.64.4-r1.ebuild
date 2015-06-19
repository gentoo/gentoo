# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/drqueue/drqueue-0.64.4-r1.ebuild,v 1.1 2015/03/14 05:11:45 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 user

DESCRIPTION="Render farm managing software"
HOMEPAGE="http://www.drqueue.org/"
SRC_URI="http://drqueue.org/files/${PN}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X python ruby"

RDEPEND="X? ( x11-libs/gtk+:2 )
	 ruby? ( dev-lang/ruby )
	 app-shells/tcsh"

DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	ruby? ( dev-lang/swig )
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
	>=dev-util/scons-0.97"

S=${WORKDIR}/DrQueue-${PV}

PATCHES=( "${FILESDIR}"/${P}-fpic.patch
	"${FILESDIR}"/${P}-git.patch )

pkg_setup() {
	enewgroup drqueue
	enewuser drqueue -1 /bin/bash /dev/null daemon,drqueue

	use python && python-single-r1_pkg_setup
}

python_prepare() {
	distutils-r1_python_prepare
	# Workaround broken SWIG path
	ln -s ../libdrqueue python/libdrqueue || die
}

src_compile() {
	if use X; then
		scons ${MAKEOPTS} build_drman=yes || die "scons failed"
	else
		scons ${MAKEOPTS} build_drqman=no || die "scons failed"
	fi

	if use python; then
		einfo "compiling python bindings"
		pushd  "${S}"/python/ > /dev/null
		distutils-r1_src_compile
		popd > /dev/null
	fi

	if use ruby; then
		einfo "compiling ruby bindings"
		cd "${S}"/ruby/
		ruby extconf.rb
		emake || die "emake failed"
	fi
}

pkg_preinst() {
	# stop daemons since script is being updated
	[ -n "$(pidof drqsd)" -a -x /etc/init.d/drqsd ] && \
			/etc/init.d/drqsd stop
	[ -n "$(pidof drqmd)" -a -x /etc/init.d/drqmd ] && \
			/etc/init.d/drqmd stop
}

src_install() {
	dodir /var/lib
	scons PREFIX="${D}"/var/lib install || die "install failed"

	# not really needed
	rm -R "${D}"/var/lib/drqueue/bin/viewcmd || die "rm failed"

	# install {conf,init,env}.d files
	for i in drqmd drqsd ; do
		newinitd "${FILESDIR}"/${PN}-0.64.3-etc-initd-${i} ${i} || die "newinitd failed"
		newconfd "${FILESDIR}"/${PN}-0.64.3-etc-confd-${i} ${i} || die "newconfd failed"
	done
	newenvd "${FILESDIR}"/${PN}-0.64.3-etc-envd-02drqueue 02drqueue || die "newenvd failed"

	# create the drqueue pid directory
	dodir /var/run/drqueue
	keepdir /var/run/drqueue

	# move logs dir to /var/log
	dodir /var/log
	mv "${D}"/var/lib/drqueue/logs "${D}"/var/log/drqueue

	# fix bins and make links for /usr/bin
	dodir /usr/bin
	local commands=( blockhost cjob jobfinfo \
			jobinfo master requeue sendjob slave )
	if use X ; then
		commands=( ${commands[@]} drqman )
	else
		# Remove drqman leftovers
		for i in etc/drqman.rc etc/drqman.conf bin/drqman ; do
			rm -v "${D}"/var/lib/drqueue/$i || die "rm failed"
		done
	fi
	for cmd in ${commands[@]} ; do
		sed -e 's|SHLIB=\$DRQUEUE_ROOT/bin/shlib|SHLIB=/var/lib/drqueue/bin/shlib|' \
			-i "${D}"var/lib/drqueue/bin/${cmd} || die "sed failed"
		dosym /var/lib/drqueue/bin/${cmd} /usr/bin/ \
				|| die "dosym failed"
	done

	# install documentation
	dodoc AUTHORS ChangeLog INSTALL \
			NEWS README README.mentalray \
			README.python setenv || die "dodoc failed"

	if use python; then
		cd "${S}"/python/
		distutils-r1_src_install
		dodir /var/lib/${PN}/python

		# Install DRKeewee web service and example python scripts
		insinto /var/lib/${PN}/python
		doins -r DrKeewee examples || die "doins failed"
		python_fix_shebang "${ED}var/lib/${PN}/python"
	fi

	if use ruby; then
		cd "${S}"/ruby/
		emake DESTDIR="${D}" install || die "emake failed"
	fi
}

pkg_postinst() {
	einfo "Edit /etc/conf.d/drqsd /etc/env.d/02drqueue"
	einfo "and /etc/conf.d/drqmd DRQUEUE_MASTER=\"hostname\""
	einfo "to reflect your master's hostname."
	if use python ; then
		einfo
		einfo "DrKeewee can be found in /var/lib/drqueue/python"
	fi
}
