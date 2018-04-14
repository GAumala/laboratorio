const knex = require('../db.js');
module.exports = () =>
  knex.schema
    .hasTable('paciente')
    .then(exists => {
      if (!exists)
        return knex.schema
          .createTable('paciente', table => {
            table.integer('rowid').primary();
            table.string('nombreAscii', 50).notNullable();
            table.string('nombre', 50).notNullable();
            table.string('correo', 80);
            table.integer('tipo').notNullable();
          })
          .createTable('doctor', table => {
            table.integer('rowid').primary();
            table.string('nombreAscii', 50).notNullable();
            table.string('nombre', 50).notNullable();
            table.string('correo', 80);
            table.boolean('esMujer');
          })
          .createTable('consulta', table => {
            table.integer('rowid').primary();
            table.date('fecha').notNullable();
            table.integer('pacienteId').notNullable();
            table.integer('doctorId');

            table.foreign('pacienteId').references('paciente.rowid');
            table.foreign('doctorId').references('doctor.rowid');
          })
          .createTable('enzimaticoPerfil', table => {
            table.float('transaminasaGOxalaxetica');
            table.float('transaminasaGPiruvica');
            table.float('fosfatasaAlcalina');
            table.float('amilasa');
            table.float('fosfatasaAcidaTotal');
            table.float('fosfatasaAcidaProstatica');
            table.float('ldh');
            table.float('cpk');
            table.float('gammaGT');
            table.float('lipasa');
            table.float('colinesterasa');
            table.string('otros');
            table.float('consultaId');

            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('ionicoPerfil', table => {
            table.float('sodio');
            table.float('potasio');
            table.float('cloro');
            table.float('calcio');
            table.float('magnesio');
            table.float('fosforo');
            table.float('amonio');
            table.string('otros');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('bioquimicoPerfil', table => {
            table.float('glucosa');
            table.float('urea');
            table.float('creatinina');
            table.float('acidoUrico');
            table.float('bilirrubinaTotal');
            table.float('bilirrubinaDirecta');
            table.float('bilirrubinaIndirecta');
            table.float('proteinasTotales');
            table.float('seroAlbumina');
            table.float('seroGlobulina');
            table.float('relacionAG');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('lipemicoPerfil', table => {
            table.float('colesterol');
            table.float('trigliceridos');
            table.float('lipidosTotales');
            table.float('hdlColesterol');
            table.float('ldlColesterol');
            table.float('hierroSerico');
            table.float('hierroTotal');
            table.float('hierroLibre');
            table.string('otros');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('coproparasitarioExamen', table => {
            table.string('consistencia', 15);
            table.string('color', 15);
            table.string('olor', 15);
            table.string('aspecto', 15);
            table.string('moco', 15);
            table.float('ph');
            table.string('sangreOculta', 15);
            table.string('floraBacteriana', 15);
            table.string('leucocitos', 15);
            table.string('hematies', 15);
            table.string('esporasDeHongos', 15);
            table.string('miceliosDeHongos', 15);
            table.string('grasaNeutra', 15);
            table.string('granulosDeAlmidon', 15);
            table.string('fibrasVegDig', 15);
            table.string('fibrasVegNoDig', 15);
            table.string('parasitos', 100);
            table.string('gram', 100);
            table.float('polimorfonucleares');
            table.float('eosinofilos');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('cartaExamen', table => {
            table.text('text');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('hemogramaExamen', table => {
            table.float('eritrocitos');
            table.float('hematocrito');
            table.float('hemaglobina');
            table.float('eritoblastos');
            table.float('reticulocitos');
            table.string('eritrosedimentacion', 15);
            table.float('vcm');
            table.float('hcm');
            table.float('mchc');
            table.float('plaquetas');
            table.float('mpv');
            table.float('pdw');
            table.float('pct');
            table.float('leucocitos');
            table.float('juveniles');
            table.float('cayados');
            table.float('segmentados');
            table.float('eosinofilos');
            table.float('basofilos');
            table.float('monocitos');
            table.float('linfocitos');
            table.string('otros');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('hemostaticoPerfil', table => {
            table.float('tiempoProtombina');
            table.float('tiempoTromboPlastina');
            table.float('fibrinogeno');
            table.string('grupoSanguineo', 1);
            table.string('factorRH', 15);
            table.float('tiempoSangria');
            table.float('tiempoCoagulacion');
            table.float('retraccionCoagulo');
            table.string('otros');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('orinaExamen', table => {
            table.float('volumenExaminado');
            table.string('color', 15);
            table.string('aspecto', 15);
            table.float('ph');
            table.string('reductoresBenedict', 10);
            table.string('proteina', 10);
            table.string('cuerpoCetonicos', 10);
            table.string('urobilinogeno', 10);
            table.string('bilirrubina', 10);
            table.string('nitritos', 10);
            table.string('sangre', 10);
            table.string('celulasEpiteliales', 15);
            table.string('leucocitos', 15);
            table.string('piocitos', 15);
            table.string('cristalesCilindros', 10);
            table.string('hematies', 15);
            table.string('mucus', 15);
            table.string('bacteriasMotiles', 15);
            table.string('otros');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('parasitologicoExamen', table => {
            table.string('color', 15);
            table.string('olor', 15);
            table.string('consistencia', 15);
            table.string('aspecto', 15);
            table.string('mocoFecal', 15);
            table.string('hematies', 15);
            table.string('hongos', 15);
            table.string('fibrasVegetal', 10);
            table.string('grasaNeutra', 10);
            table.string('almidones', 10);
            table.string('parasitos', 80);
            table.string('otros');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          })
          .createTable('serologicoPerfil', table => {
            table.string('vdrlCualitativa', 80);
            table.string('vdrlCuantitativa', 80);
            table.string('asto', 80);
            table.string('pcReactiva', 80);
            table.string('raTest', 80);
            table.string('monoTest', 80);
            table.string('eberthO', 10);
            table.string('eberthH', 10);
            table.string('paratificoA', 10);
            table.string('proteux0x19', 10);
            table.string('proteux0x12', 10);
            table.string('otros');

            table.integer('consultaId');
            table.foreign('consultaId').references('consulta.rowid');
          });
      return Promise.reject();
    })
    .then(
      () => Promise.resolve(),
      () =>
        knex('ionicoPerfil')
          .truncate()
          .then(() => knex('enzimaticoPerfil').truncate())
          .then(() => knex('paciente').truncate())
          .then(() => knex('doctor').truncate())
          .then(() => knex('consulta').truncate())
    );

if (require.main === module) module.exports().then(() => knex.destroy());
