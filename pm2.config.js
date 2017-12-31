module.exports = {
    apps: [{
        script: 'src/server/app.coffee',
        name: 'CertRegTemplateAdmin',
        interpreter: '/usr/bin/coffee',
        out_file: '/mnt/MC/work_space/CertReg/TemplateAdmin/logs/' + process.env.HOSTNAME + '/out.log',
        err_file: '/mnt/MC/work_space/CertReg/TemplateAdmin/logs/' + process.env.HOSTNAME + '/err.log',
        env: {
            NODE_ENV: 'production'
        }
    }]
};
