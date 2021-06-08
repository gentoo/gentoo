# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="PKCS#11 provider cryptographic hardware"
HOMEPAGE="https://sourceforge.net/projects/opencryptoki"
SRC_URI="mirror://sourceforge/opencryptoki/${PV}/${P}.tgz"
S="${WORKDIR}/${PN}"

# Upstream is looking into relicensing it into CPL-1.0 entirely; the CCA
# token sources are under CPL-1.0 already.
LICENSE="CPL-0.5"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~s390 ~x86"
IUSE="debug +tpm"

DEPEND="
	tpm? ( app-crypt/trousers )
	>=dev-libs/openssl-1.1.0:0=
"
RDEPEND="
	${DEPEND}
	acct-group/pkcs11
"

DOCS=(
	README AUTHORS FAQ TODO
	doc/openCryptoki-HOWTO.pdf
)

# tests right now basically don't exist; the only available thing would
# test against an installed copy and would kill a running pcscd, all
# things that we're not interested to.
RESTRICT=test

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	# package uses ${localstatedir}/lib as the default path, so if we
	# leave it to econf, it'll create /var/lib/lib.

	# Since upstream by default seem to enable any possible token, even
	# when they don't seem to be used, we limit ourselves to the
	# software emulation token (swtok) and if the user enabled the tpm
	# USE flag, tpmtok.  The rest of the tokens seem to be hardware- or
	# software-dependent even when they build fine without their
	# requirements, but until somebody asks for those, I'd rather not
	# enable them.

	# We don't use --enable-debug because that tinkers with the CFLAGS
	# and we don't want that. Instead we append -DDEBUG which enables
	# debug information.
	use debug && append-flags -DDEBUG

	econf \
		--localstatedir=/var \
		--enable-fast-install \
		--disable-debug \
		--enable-daemon \
		--enable-library \
		--disable-icatok \
		--enable-swtok \
		$(use_enable tpm tpmtok) \
		--disable-ccatok
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# Install libopencryptoki in the standard directory for libraries.
	mv "${ED}"/usr/$(get_libdir)/opencryptoki/libopencryptoki.so* "${ED}"/usr/$(get_libdir) || die
	rm "${ED}"/usr/$(get_libdir)/pkcs11/libopencryptoki.so || die
	dosym ../libopencryptoki.so /usr/$(get_libdir)/pkcs11/libopencryptoki.so

	# Remove compatibility symlinks as we _never_ required those and
	# they seem unused even upstream.
	find "${ED}" -name 'PKCS11_*' -delete || die

	# We replace their ld.so and init files (mostly designed for RedHat
	# as far as I can tell) with our own replacements.
	rm -rf "${ED}"/etc/ld.so.conf.d "${ED}"/etc/rc.d || die

	# make sure that we don't modify the init script if the USE flags
	# are enabled for the needed services.
	cp "${FILESDIR}"/pkcsslotd.init.2 "${T}"/pkcsslotd.init || die
	use tpm || sed -i -e '/use tcsd/d' "${T}"/pkcsslotd.init
	newinitd "${T}/pkcsslotd.init" pkcsslotd

	# We create /var dirs at runtime as needed, so don't bother installing
	# our own.
	rm -r "${ED}"/var/{lib,lock} || die
}
