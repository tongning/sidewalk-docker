FROM node:argon
RUN npm install grunt grunt-contrib-concat grunt-contrib-watch -g
#RUN ls /home/app
COPY ./rungrunt.sh /usr/local/bin/rungrunt.sh
WORKDIR /home/app
CMD ["sh","/usr/local/bin/rungrunt.sh"]
#CMD ["grunt"]

#CMD ["grunt","watch"]

#RUN grunt

#RUN grunt watch
